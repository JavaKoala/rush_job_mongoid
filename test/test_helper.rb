# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  SimpleCov.coverage_dir('test/coverage')
end

require_relative '../test/dummy/config/environment'
require 'rails/test_help'
require 'database_cleaner-mongoid'
