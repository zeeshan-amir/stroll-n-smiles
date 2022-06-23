class User < ApplicationRecord
  has_one :setting, dependent: :destroy

  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :rooms_reservations, through: :rooms, source: :reservations
  has_many :notifications, dependent: :destroy

  has_many :sender_conversations,
           class_name: "Conversation",
           foreign_key: :sender_id,
           inverse_of: :sender,
           dependent: :nullify

  has_many :recipient_conversations,
           class_name: "Conversation",
           foreign_key: :recipient_id,
           inverse_of: :recipient,
           dependent: :nullify

  has_many :reviews_as_guest,
           class_name: "GuestReview",
           foreign_key: :guest_id,
           inverse_of: :guest,
           dependent: :destroy

  has_many :reviews_as_host,
           class_name: "HostReview",
           foreign_key: :host_id,
           inverse_of: :host,
           dependent: :destroy

  validates :fullname, presence: true, length: { maximum: 50 }
  validates :phone_number, uniqueness: true, allow_nil: true

  after_create :add_setting

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[facebook]

  def self.from_omniauth(auth)
    AuthenticateWithOmniAuth.call(auth)
  end

  def guest_reviews
    GuestReview.where(host_id: id)
  end

  def host_reviews
    HostReview.where(guest_id: id)
  end

  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  def send_pin
    SendSms.call(to: phone_number, body: "Your pin is #{pin}")
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if pin == entered_pin
  end

  def active_host?
    merchant_id.present?
  end

  def email_enabled?
    setting.enable_email?
  end

  def sms_enabled?
    setting.enable_sms? && phone_verified?
  end

  def supplier?
    rooms.present?
  end

  private

  def add_setting
    Setting.create(user: self, enable_sms: true, enable_email: true)
  end
end
