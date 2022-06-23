class Plan < ApplicationRecord
  validates :name, presence: true
  validates :price_monthly, :price_semiannual, :price_annual,
            presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :by_id, -> { order(id: :ASC) }
end
