require "test_helper"

class HostReviewTest < ActiveSupport::TestCase
  should belong_to(:host).class_name("User")
end
