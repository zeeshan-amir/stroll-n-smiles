require "test_helper"

class AdminTest < ActiveSupport::TestCase
  should have_secure_password

  should validate_presence_of(:email)
  should validate_uniqueness_of(:email).case_insensitive
  should validate_length_of(:password).is_at_least(8)
end
