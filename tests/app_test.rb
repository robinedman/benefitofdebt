ENV['RACK_ENV'] = 'test'

require 'turn/autorun'
require 'rack/test'
require 'json'
require_relative '../app'

class AppTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    Cuba
  end

  def test_default_route_serves_page
    get '/'

    assert(last_response.ok?)
    assert(last_response.body.include?('Benefit of Debt'))
  end

  # def test_get_favourite_language
  #   get_user_favourite 'rubinius'
  #   answer = JSON.parse(last_response.body)

  #   assert_equal('Ruby', answer['favourite'])
  # end

  # def test_nonexistent_username_returns_error_code
  #   get_user_favourite 'auserthatdoesnotexist'

  #   refute_equal(200, last_response.status)
  # end

end
