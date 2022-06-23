class NotifyReservationApproval < ApplicationService
  def initialize(reservation)
    @reservation = reservation
    @room = reservation.room
    @host = reservation.room.user
    @guest = reservation.user
  end

  def call
    send_email_to_guest
    send_sms_to_host

    true
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  private

  attr_reader :reservation, :room, :host, :guest

  def send_email_to_guest
    return unless guest.email_enabled?

    ReservationMailer.send_email_to_guest(guest, room).deliver_later
  end

  def send_sms_to_host
    return unless host.sms_enabled?

    SendSms.call(
      to: host.phone_number,
      body: "#{host.fullname} booked your '#{room.name}'",
    )
  end
end
