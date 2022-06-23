require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  should belong_to(:sender).class_name("User").with_foreign_key(:sender_id)
  should belong_to(:recipient).class_name("User").with_foreign_key(:recipient_id)
  should have_many(:messages).dependent(:destroy)

  should validate_uniqueness_of(:sender_id)
  should validate_uniqueness_of(:recipient_id)

  should "find conversations where specified user is involved" do
    user = users(:luke).id

    expected_sql = Conversation.where(sender_id: user).
      or(Conversation.where(recipient_id: user)).to_sql

    assert_equal Conversation.involving(user).to_sql, expected_sql
  end

  should "find conversations between two specified users" do
    user_one = users(:luke).id
    user_two = users(:yoda).id

    expected_sql = Conversation.
      where(sender_id: user_one, recipient_id: user_two).
      or(Conversation.where(sender_id: user_two, recipient_id: user_one)).
      to_sql

    assert_equal Conversation.between(user_one, user_two).to_sql, expected_sql
  end
end
