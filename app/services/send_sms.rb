class SendSms < ApplicationService
  # TODO: Set number in ENV variable
  FROM_PHONE_NUMBER = "+17038549336".freeze

  def initialize(to:, body:)
    @to = to
    @body = body
    @client = Twilio::REST::Client.new
  end

  def call
    client.messages.create(
      from: FROM_PHONE_NUMBER,
      to: to,
      body: body,
    )

    true
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  private

  attr_reader :to, :body, :client
end
