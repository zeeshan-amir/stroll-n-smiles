class Room < ApplicationRecord
  ACCEPTED_PAYMENT_METHODS = %w(Cash PayPal MasterCard Visa DinersClub).freeze
  DEAFULT_SEARCH_RADIUS    = 10

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :guest_reviews, dependent: :destroy
  has_many :calendars, dependent: :destroy

  has_many :open_hours_week_days,
           class_name: "OpenHours::WeekDay",
           dependent: :destroy

  has_many :open_hours_special_days,
           class_name: "OpenHours::SpecialDay",
           dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
  validates :summary, presence: true
  validates :has_lobby, inclusion: { in: [true, false] }
  validates :has_xrays, inclusion: { in: [true, false] }
  validates :has_heating, inclusion: { in: [true, false] }
  validates :has_internet, inclusion: { in: [true, false] }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :practitioners, numericality: { greater_than: 0 }
  validates :stations, numericality: { greater_than: 0 }
  validates :open_hours, presence: true
  validates :active, inclusion: { in: [true, false] }

  validate :accepted_payment_methods

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  before_save :deactivate, unless: :approved?

  scope :active,      -> { where(active: true) }
  scope :prioritized, -> { order(search_priority: :ASC) }
  scope :featured,    -> { where(featured: true).order(featured_order: :ASC) }

  def self.near_by(location, radius = 10)
    active.near(location, radius, order: "distance")
  end

  def self.available_on(date)
    select { |room| room.available_on?(date) }
  end

  def self.maximum_price
    maximum(:price).to_i
  end

  def self.minimum_price
    minimum(:price).to_i
  end

  def open_hours_by_week_day
    open_hours = open_hours_week_days.by_day

    OpenHours::WeekDay.week_days.each_key.with_object({}) do |day, result|
      result[day] = open_hours[day].presence || []
    end
  end

  def open_hours_by_special_day
    open_hours_special_days.order(:month, :day, :open).group_by do |open_hours|
      { day: open_hours.day, month: open_hours.month }
    end
  end

  def active_nearbys(total_rooms)
    nearbys(total_rooms).try(:active) || []
  end

  def availability_on(date)
    RoomWithAvailability.
      new(room: self, date: Date.parse(date)).
      available_reservation_times
  end

  def available_on?(date)
    availability_on(date).count.positive?
  end

  def cover_photo(size = :medium)
    return "blank.jpg" unless photos.length.positive?

    photos.first.fitted(size)
  end

  def average_rating
    return 0 if guest_reviews.count.zero?

    guest_reviews.average(:star).round
  end

  def ready?
    approved? && photos.present? && open_hours_week_days.present?
  end

  def update_active_status
    update(active: false) unless ready?
  end

  private

  def accepted_payment_methods
    if payment_methods.empty?
      errors.add(:payment_methods, "must be specified")
    else
      payment_methods.each do |payment_method|
        unless ACCEPTED_PAYMENT_METHODS.include?(payment_method)
          errors.add(:payment_methods, "can't include '#{payment_method}'")
        end
      end
    end
  end

  def deactivate
    self.active = false
  end
end
