ENV['RACK_ENV'] = 'test'

require 'turn/autorun'
require 'rack/test'
require 'json'
require_relative '../app'

class BenefitOfDebtTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Cuba
  end
end
