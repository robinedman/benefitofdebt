ENV['RACK_ENV'] = 'test'

require 'turn/autorun'
require 'rack/test'
require 'json'
require_relative '../app'

Turn.config.natural = true

class BenefitOfDebtTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Cuba
  end
end
