require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'json'

Dotenv.load
Bundler.require

Dir.glob('./lib/**/*.rb') { |f| require f }
require './conf_admin_app'

require 'securerandom'
set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }

run ConfAdminApp
