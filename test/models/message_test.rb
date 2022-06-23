require "test_helper"

class MessageTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:conversation)

  should validate_presence_of(:context)
  should validate_presence_of(:conversation_id)
  should validate_presence_of(:user_id)

  should "show correct 'message time'" do
    message = messages(:there_is_no_escape)
    message.created_at = Date.new(2020, 1, 1)

    assert_equal " 1-Jan-2020", message.message_time
  end

  should "create notification after being created" do
    message = Message.new(
      context: "Don't make me destroy you.",
      user: users(:anakin),
      conversation: conversations(:i_am_your_father),
    )

    assert_difference "Notification.count" do
      message.save_and_notify
    end
  end

  should "confirm message belongs to user" do
    message = messages(:there_is_no_escape)

    assert message.belongs_to?(users(:luke))
  end

  should "confirm message does not belong to not owner user" do
    message = messages(:there_is_no_escape)

    assert_not message.belongs_to?(users(:han))
  end
end
