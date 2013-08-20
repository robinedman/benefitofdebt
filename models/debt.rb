class Debt
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  field :amount, type: Integer
  field :currency, type: Integer, default: 'SEK'
  field :creditor, type: String # user id
  field :debtor, type: String # user id

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
end