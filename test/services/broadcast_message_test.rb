require "test_helper"

class BroadcastMessageTest < ActionDispatch::IntegrationTest
  include ActionCable::TestHelper

  should "broadcast message" do
    message = messages(:there_is_no_escape)
    channel_name = "conversation_#{message.conversation_id}"

    BroadcastMessage.call(message, :create)

    assert_broadcasts channel_name, 1
  end
end
