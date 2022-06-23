require "test_helper"

class SettingTest < ActiveSupport::TestCase
  should belong_to(:user)
end
