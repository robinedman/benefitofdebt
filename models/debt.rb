class Debt
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  belongs_to :expense
  
  field :amount, type: Integer
  field :currency, type: Integer, default: 'SEK'
  field :creditor, type: String # user email
  field :debtor, type: String # user email

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
end
