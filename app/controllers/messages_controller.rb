class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, except: :destroy

  def index
    @recipient = @conversation.recipient_for(current_user)

    if @recipient.blank?
      redirect_to(
        conversations_path,
        alert: "You don't have permission to view this.",
      )
    end
  end

  def create
    message = @conversation.messages.new(message_params)

    if message.save_and_notify
      BroadcastMessage.call(message, :create)
    end
  end

  def destroy
    message = Message.find(params[:id])

    if message.belongs_to?(current_user)
      message.destroy
      BroadcastMessage.call(message, :destroy)
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:context, :user_id)
  end
end
