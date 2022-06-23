class ReservationMailer < ApplicationMailer
  CONTACT_MAIL = ENV["CONTACT_EMAIL"]

  def send_email_to_guest(guest, room)
    @recipient = guest
    @room = room
    mail(to: @recipient.email, subject: "Enjoy You Treatment! ")
  end

  def new_customer(subscription)
    @name = subscription.name
    @email = subscription.email
    @plan = Plan.find(subscription.plan).name
    @message = subscription.message.presence || "No message"


    mail(to: CONTACT_MAIL, subject: "New #{@plan} customer!")
  end
end
