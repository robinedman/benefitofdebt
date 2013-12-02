require_relative 'test_setup'

module ExpenseAndDebtTest
  class Base < BenefitOfDebtTest
    def tabula_rasa
      User.destroy_all(email: 'first_debtor@example.com')
      User.destroy_all(email: 'second_debtor@example.com')
      User.destroy_all(email: 'creditor@example.com')
    end

    def setup
      tabula_rasa

      @first_debtor = User.create!(email: 'first_debtor@example.com',
                                   hashed_password: 'firstdebtor123')
      @second_debtor = User.create!(email: 'second_debtor@example.com',
                                   hashed_password: 'firstdebtor123')
      @creditor = User.create!(email: 'creditor@example.com',
                               hashed_password: 'thecreditor123')
    end

    def teardown
      tabula_rasa
    end
  end

  class Various < Base
    def test_create_expense
      expense = @creditor.expenses.create!(amount: 105)
      assert_equal(105, expense.amount)
    end
  end

  class BuySomeoneSomething < Base
    def setup
      super
      @expense = buy_someone_something
    end


    def test_only_puts_one_of_us_in_debt
      assert_equal(1, @expense.debts.length)
    end

    def test_puts_someone_in_debt_to_me
      assert_equal(@first_debtor.email, @expense.debts.first.debtor)
      assert_equal(@creditor.email, @expense.debts.first.creditor)
    end

    def test_makes_someone_owe_that_amount
      assert_equal(105, @expense.debts.first.amount)
    end

    private

    def buy_someone_something
      expense = @creditor.expenses.create!(amount: 105)
      expense.split([{user: @first_debtor.email, amount: 105}])
      return expense
    end

  end

  class SplitEqually < Base
    def setup
      super
      @expense = expense_splitted_equally
    end


    def test_only_puts_one_of_us_in_debt
      assert_equal(1, @expense.debts.length)
    end

    def test_puts_someone_in_debt_to_me
      assert_equal(@first_debtor.email, @expense.debts.first.debtor)
      assert_equal(@creditor.email, @expense.debts.first.creditor)
    end

    def test_makes_someone_owe_half_the_amount
      assert_equal((@expense.amount / 2), @expense.debts.first.amount)
    end

    private

    def expense_splitted_equally
      expense = @creditor.expenses.create!(amount: 1000)
      expense.split_equally([@creditor, @first_debtor])
      return expense
    end
  end

  class SplitInequally < Base
    def setup
      super
      @expense = expense_splitted_inequally
    end


    def test_only_puts_one_of_us_in_debt
      assert_equal(1, @expense.debts.length)
    end

    def test_puts_someone_in_debt_to_me
      assert_equal('first_debtor@example.com', @expense.debts.first.debtor)
      assert_equal('creditor@example.com', @expense.debts.first.creditor)
    end

    def test_makes_someone_owe_me_that_amount
      assert_equal(700, @expense.debts.first.amount)
    end

    def test_raises_exception_when_split_does_not_add_up
      expense = @creditor.expenses.create!(amount: 1000)

      assert_raises(Expense::SplitDoesNotAddUpError) do
        expense.split([{user: @creditor.email, amount: 299}, 
                       {user: @first_debtor.email, amount: 700}])  
      end
    end

    private

    def expense_splitted_inequally
      expense = @creditor.expenses.create!(amount: 1000)
      expense.split([{user: @creditor.email, amount: 300}, 
                     {user: @first_debtor.email, amount: 700}])
      return expense
    end
  end
end


  

  
    
  

