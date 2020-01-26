ENV['RACK_ENV'] = 'test'

# load test env variables
require 'dotenv'
Dotenv.load('./.env.test')

require 'sinatra'
require 'bundler'
Bundler.require

# require testing components
require 'rack/test'
require 'minitest/autorun'
Dir.glob('./spec/factories/*.rb') { |f| require f }

# require application components
Dir.glob('./lib/**/*.rb') { |f| require f }
require './conf_admin_app'
require 'json'

class BaseSpec < Minitest::Spec
  def self.expand_path(path)
    File.expand_path(path, __FILE__)
  end
end

class ConfAdminAppSpec < BaseSpec
  include Rack::Test::Methods

  def app
    ConfAdminApp
  end
end
