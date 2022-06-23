class Reservation < ApplicationRecord
  default_scope { order(datetime: :ASC) }

  enum status: { waiting: 0, approved: 1, declined: 2 }

  belongs_to :user
  belongs_to :room

  validate :availability, on: :create

  def self.on(date)
    where(datetime: date.beginning_of_day..date.end_of_day)
  end

  def self.current_week_revenue(user)
    joins(:room).
      where(status: 1, rooms: { user_id: user.id }).
      where(arel_table[:updated_at].gteq(1.week.ago.round)).
      order(updated_at: :asc)
  end

  def save_and_notify
    if save
      create_notification

      self
    else
      false
    end
  end

  def time
    datetime.strftime("%H:%M")
  end

  private

  def availability
    if Reservation.find_by(room_id: room_id, datetime: datetime).present?
      errors.add(:datetime, "not available for booking")
    end
  end

  def create_notification
    Notification.new(
      content: "New Booking from #{user.fullname}",
      user_id: room.user_id,
      url: Rails.application.routes.url_helpers.suppliers_reservations_path,
    ).save_and_broadcast
  end
end
