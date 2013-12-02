class Expense
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  embedded_in :user
  has_many :debts

  field :amount, type: Integer
  field :currency, type: String, default: 'SEK'
  field :description, type: String
  field :purchase_time, type: Time
  field :receipt_image_url, type: String

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
  
  def split_equally(users)
    users_amounts = []
    users.each do |user|
      users_amounts << {user: user.email, amount: self.amount / users.length.to_f}
    end
    split(users_amounts)
  end


  def split(users_amounts)
    debts = []
    sum = 0
    users_amounts.each do |user_amount|
        user_email = user_amount[:user]
        amount = user_amount[:amount]
        sum += amount
        debts << Debt.create!(amount: amount,
                              creditor: self.user.email,
                              debtor: user_email) unless user_email == self.user.email
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
