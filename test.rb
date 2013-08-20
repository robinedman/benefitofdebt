require_relative 'init'

user = User.where(first_name: 'Kalle').first
carrots = user.expenses.create(amount: 100)
carrots.split_equally(['Sickan', 'Vanheden'])
require 'pp'
pp carrots.debts