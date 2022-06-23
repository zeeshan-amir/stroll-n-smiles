require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  should belong_to(:user)

  should "save and schedule notification job (broadcast)" do
    notification = Notification.new(
      content: "New message from Leia",
      user: users(:leia),
      url: "tatooine/r2d2/helpme",
    )

    assert_enqueued_jobs 1 do
      notification.save_and_broadcast
    end
  end
end
