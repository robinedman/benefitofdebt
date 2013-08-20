class Debt
  include Mongoid::Document
  include Mongoid::Timestamps
  include LingonberryMongoidImportExport
  
  field :amount, type: Integer
  field :to, type: String
  field :expense, type: String

  externally_readable :amount,
                      :currency

  rest_interface :create,
                 :read,
                 :update,
                 :delete
end