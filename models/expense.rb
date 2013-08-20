class Expense
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  embedded_in :user
  has_many :debts

  field :amount, type: Integer
  field :currency, type: String, default: 'SEK'

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
  
  def split_equally(users)
    users_amounts = []
    users.each do |user_id|
      users_amounts << {user: user_id, amount: self.amount / users.length}
    end
    split(users_amounts)
  end


  def split(users_amounts)
    debts = []
    sum = 0
    p users_amounts
    users_amounts.each do |user_amount|
        user_id = user_amount[:user]
        amount = user_amount[:amount]
        sum += amount
        debts << Debt.new(amount: amount,
                          creditor: self.user,
                          debtor: user) unless user_id == self.user.id
    end
    
    raise SplitDoesNotAddUpError unless sum == self.amount

    debts.each do |debt|
      debt.save!
      self.debts << debt
    end
  end

  class SplitDoesNotAddUpError < StandardError
  end
end
