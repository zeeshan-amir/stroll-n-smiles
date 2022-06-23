class Calendar < ApplicationRecord
  enum status: {
    available: 0,
    not_available: 1,
  }

  belongs_to :room

  validates :day, presence: true
end
