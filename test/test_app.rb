require 'helper'

class NameApp
  include Newark

  before do
    if params[:key] && params[:key] != '23'
      response.status = 403
      false
    end
  end

  def upcase(str)
    str.upcase
  end

  get '/upcaser' do
    upcase(params[:name])
  end

  get '/hello1' do
    hello
  end

  get '/fail' do
    'This should not be reached'
  end

  get '/hello2', :hello

  private

  def hello
    'Hello'
  end
end

class TestApp < MiniTest::Unit::TestCase

  include Rack::Test::Methods

  def app
    Rack::Lint.new(NameApp.new)
  end

  def test_instance_method_access
    get '/upcaser', { name: 'mike' }
    assert last_response.ok?
    assert_equal 'MIKE', last_response.body
  end

  def test_alternate_action_invocation
    get '/hello1'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body

    get '/hello2'
    assert last_response.ok?
    assert_equal 'Hello', last_response.body
  end

  def test_before_hooks_halting_execution
    get '/fail', { key: '1234' }
    refute last_response.ok?
    assert_equal 403, last_response.status
    assert_equal '', last_response.body
  end

end
