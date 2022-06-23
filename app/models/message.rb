class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates :context, :conversation_id, :user_id, presence: true

  def save_and_notify
    if save
      create_notification

      self
    else
      false
    end
  end

  def message_time
    created_at.strftime("%v")
  end

  def belongs_to?(user)
    self.user == user
  end

  private

  def create_notification
    if conversation.sender_id == user_id
      from_user_id = conversation.sender_id
      to_user_id   = conversation.recipient_id
    else
      from_user_id = conversation.recipient_id
      to_user_id   = conversation.sender_id
    end

    Notification.new(
      content: "New message from #{User.find(from_user_id).fullname}",
      user_id: to_user_id,
      url: conversation.url,
    ).save_and_broadcast
  end
end
