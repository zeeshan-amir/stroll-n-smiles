class Notification < ApplicationRecord
  belongs_to :user

  def save_and_broadcast
    if save
      NotificationJob.perform_later(self)

      self
    else
      false
    end
  end
end
