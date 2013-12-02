require_relative 'test_setup'

class ExpenseAndDebtTest < BenefitOfDebtTest
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

  def test_create_expense
    expense = @creditor.expenses.create!(amount: 105)
    assert_equal(105, expense.amount)
  end

  def expense_splitted
    expense = @creditor.expenses.create!(amount: 1000)
    expense.split_equally([@creditor, @first_debtor])
    return expense
  end

  def test_split_expense_with_someone_only_puts_one_of_us_in_debt
    expense = expense_splitted

    assert_equal(1, expense.debts.length)
  end

  def test_split_expense_with_someone_puts_that_someone_in_debt_to_me
    expense = expense_splitted

    assert_equal('first_debtor@example.com', expense.debts.first.debtor)
    assert_equal('creditor@example.com', expense.debts.first.creditor)
  end

  def test_split_expense_with_someone_makes_someone_owe_half_the_amount
    expense = expense_splitted
    
    assert_equal((expense.amount / 2), expense.debts.first.amount)
  end


  def teardown
    tabula_rasa
  end

end
