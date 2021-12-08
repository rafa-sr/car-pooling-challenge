# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'simplecov'
require 'bundler'
require 'webmock/rspec'
require 'open3'

SimpleCov.start do
  add_group 'Models', 'models'
  add_group 'Controllers', 'controllers'
  add_group 'Services', 'services'
  add_filter 'config'
  add_filter 'vendor'
  add_filter 'spec'
  minimum_coverage 90
end

# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'app')
Bundler.require(:default, :test)

# Disable webrequests
WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.dirname(__FILE__) + '/factories/*.rb'].sort.each { |file| require file }

set :environment, :test

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include FactoryBot::Syntax::Methods
  conf.include JsonSpec::Helpers
  conf.order = :random

  conf.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  conf.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  conf.before do
    DatabaseCleaner.start
  end

  conf.after do
    DatabaseCleaner.clean
  end

  conf.after :suite do
    unless ENV['TEST_LINTER_OFF'] == 'true'
      puts ''
      rubocop_command = 'bundle exec rubocop'
      raise 'RuboCop Errors' unless system rubocop_command
    end
  end
end

def app
  Sinatra::Application
end
