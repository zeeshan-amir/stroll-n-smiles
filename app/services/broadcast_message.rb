class BroadcastMessage < ApplicationService
  def initialize(message, action)
    @message = message
    @action = action.to_s
  end

  def call
    ActionCable.server.broadcast(stream, broadcast_params)

    true
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  private

  attr_reader :message, :action

  def broadcast_params
    {
      action: action,
      id: message.id,
      message: rendered_message,
      user_id: message.user_id.to_s,
    }
  end

  def stream
    "conversation_#{message.conversation.id}"
  end

  def rendered_message
    ApplicationController.renderer.render(
      partial: "messages/message",
      locals: { message: message, user: message.user },
    )
  end
end
