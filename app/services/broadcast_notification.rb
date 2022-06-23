class BroadcastNotification < ApplicationService
  def initialize(notification)
    @notification = notification
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

  attr_reader :notification

  def stream
    "notification_#{notification.user.id}"
  end

  def broadcast_params
    {
      message: rendered_notification,
      unread: notification.user.unread,
    }
  end

  def rendered_notification
    ApplicationController.render(
      partial: "notifications/notification",
      locals: { notification: notification },
    )
  end
end
