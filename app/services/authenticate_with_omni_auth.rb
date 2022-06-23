class AuthenticateWithOmniAuth < ApplicationService
  def initialize(auth)
    @auth = auth
  end

  def call
    user_with_email || user_with_uid
  rescue StandardError => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")

    false
  end

  private

  attr_reader :auth

  def user_with_email
    User.where(email: auth.info.email).first
  end

  def user_with_uid
    User.where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.fullname = auth.info.name
      user.image = auth.info.image
      user.uid = auth.uid
      user.provider = auth.provider

      user.skip_confirmation!
    end
  end
end
