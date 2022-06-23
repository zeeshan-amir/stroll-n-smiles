class NotificationJob < ApplicationJob
  queue_as :default

  def perform(notification)
    notification.user.increment(:unread).save

    BroadcastNotification.call(notification)
  end
end
