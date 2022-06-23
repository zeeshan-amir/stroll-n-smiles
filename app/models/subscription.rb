class Subscription
  include ActiveModel::Model

  attr_accessor :name, :email, :plan, :message

  validates :name, presence: true
  validates :email, presence: true
  validates :plan, presence: true
  validates :message, length: { maximum: 255 }
end
