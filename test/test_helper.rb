ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "shoulda/matchers"
require "minitest/autorun"
require "bcrypt"
require "active_storage_validations/matchers"

require_relative "fake_sms"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end

module ActiveSupport
  class TestCase
    extend ActiveStorageValidations::Matchers
    include FactoryBot::Syntax::Methods
    include Devise::Test::IntegrationHelpers

    fixtures :all
  end
end
