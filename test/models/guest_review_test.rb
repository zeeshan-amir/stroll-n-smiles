require "test_helper"

class GuestReviewTest < ActiveSupport::TestCase
  should belong_to(:guest).class_name("User")
end
