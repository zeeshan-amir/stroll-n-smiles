class Conversation < ApplicationRecord
  belongs_to :sender,
             class_name: "User",
             foreign_key: :sender_id,
             inverse_of: :sender_conversations

  belongs_to :recipient,
             class_name: "User",
             foreign_key: :recipient_id,
             inverse_of: :recipient_conversations

  has_many :messages, dependent: :destroy

  validates :sender_id, :recipient_id, uniqueness: true

  def self.involving(user)
    where(sender_id: user).or(where(recipient_id: user))
  end

  def self.between(user_one, user_two)
    where(sender_id: user_one, recipient_id: user_two).
      or(where(sender_id: user_two, recipient_id: user_one))
  end

  def messages_by_date
    messages.order("created_at DESC")
  end

  def recipient_for(user)
    case user
    when sender    then recipient
    when recipient then sender
    end
  end

  def url
    Rails.application.routes.url_helpers.conversation_messages_path(self)
  end
end
