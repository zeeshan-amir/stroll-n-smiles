module OpenHours
  class WeekDay < ApplicationRecord
    enum week_day: {
      monday: 1,
      tuesday: 2,
      wednesday: 3,
      thursday: 4,
      friday: 5,
      saturday: 6,
      sunday: 7,
    }

    belongs_to :room

    validates :week_day, presence: true
    validates :open, :close, presence: true
    validate :no_overlap
    validate :close_is_greater_than_open

    after_destroy :update_room_active_status

    def self.find_overlaps(week_day:, open:, close:)
      where(week_day: week_day).
        where(arel_table[:open].lt(close)).
        where(arel_table[:close].gt(open))
    end

    def self.by_day
      order(:week_day, :open).group_by(&:week_day)
    end

    def self.on(date)
      where(week_day: date.cwday)
    end

    private

    def update_room_active_status
      room.update_active_status
    end

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
      search_params = slice(:week_day, :open, :close).symbolize_keys

      room.
        open_hours_week_days.
        where.not(id: id).
        find_overlaps(search_params).
        present?
    end
  end
end
