class Expense
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  embedded_in :user

  field :amount, type: Integer
  field :currency, type: String, default: 'SEK'
  field :debtors, type: Array

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
  
end
