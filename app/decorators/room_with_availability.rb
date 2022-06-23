class RoomWithAvailability < SimpleDelegator
  attr_reader :date

  def initialize(room:, date:)
    @date = date.to_date

    super(room)
  end

  def available_reservation_times
    (reservation_times - reservations.on(date).map(&:time)).sort
  end

  def reservation_times
    date_open_hours.each_with_object([]) do |open_hours, times|
      time = open_hours.open

      while time < open_hours.close
        times << time.strftime("%H:%M")

        time += appointment_duration.seconds_since_midnight
      end
    end
  end

  def available?
    available_reservation_times.present?
  end

  private

  def date_open_hours
    open_hours_special_days.on(date).presence || open_hours_week_days.on(date)
  end
end
