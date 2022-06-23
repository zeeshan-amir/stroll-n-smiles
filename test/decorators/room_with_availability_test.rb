require "test_helper"

class RoomWithAvailabilityTest < ActiveSupport::TestCase
  should "find reservation times on date" do
    room = rooms(:first_jedi_temple)
    room.appointment_duration = "1:30"
    room_with_availability = RoomWithAvailability.new(
      room: room,
      date: Date.today.sunday,
    )
    times = %w[08:00 09:30 11:00 12:30 15:00 16:30 18:00 19:30]

    assert_equal times, room_with_availability.reservation_times

    room.appointment_duration = "2:00"

    room_with_availability = RoomWithAvailability.new(
      room: room,
      date: Date.today.sunday,
    )
    times = %w[08:00 10:00 12:00 15:00 17:00 19:00]

    assert_equal times, room_with_availability.reservation_times
  end

  should "find available reservation times for date" do
    room = rooms(:garbage_compactor)
    room.appointment_duration = "1:00"

    room_with_availability = RoomWithAvailability.new(
      room: room,
      date: Date.new(1977, 5, 25),
    )
    times = %w[07:00 08:00 10:00 11:00 12:00]

    assert_equal times, room_with_availability.available_reservation_times
  end
end
