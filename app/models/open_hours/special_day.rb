module OpenHours
  class SpecialDay < ApplicationRecord
    belongs_to :room

    validates :day, :month, presence: true, numericality: { only_integer: true }
    validates :open, :close, presence: true, if: :day_room_active?
    validate :no_overlap
    validate :close_is_greater_than_open

    def self.find_overlaps(day:, month:, open:, close:)
      where(day: day, month: month).
        where(arel_table[:open].lt(close)).
        where(arel_table[:close].gt(open))
    end

    def self.on(date)
      where(day: date.day, month: date.month)
    end

    def closed?
      open.nil? || close.nil?
    end

    def day_room_active?
      self.class.
        where(day: day, month: month, room_id: room_id).
        where.not(id: id).
        present?
    end

    private

    def no_overlap
      if room.present? && overlaps?
        errors.add(:base, "Open/Close period overlaps with existing period")
      end
    end

    def close_is_greater_than_open
      return if close.blank? || open.blank?

      if open >= close
        errors.add(:close, "can't be greater or equal than 'open'")
      end
    end

    def overlaps?
      search_params = slice(:day, :month, :open, :close).symbolize_keys

      room.
        open_hours_special_days.
        where.not(id: id).
        find_overlaps(search_params).
        present?
    end
  end
end
