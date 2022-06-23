require "test_helper"

class ReservationTest < ActiveSupport::TestCase
  should define_enum_for(:status).
    with_values(waiting: 0, approved: 1, declined: 2)

  should belong_to(:user)
  should belong_to(:room)

  should "order reservations by datetime by default" do
    expected_sql = Reservation.order(datetime: :ASC).to_sql

    assert_equal Reservation.all.to_sql, expected_sql
  end

  should "find reservations for specified user, ordered by last updated" do
    user = users(:luke)
    expected_sql = Reservation.
      joins(:room).
      where(status: 1, rooms: { user_id: user.id }).
      where(Reservation.arel_table[:updated_at].gteq(1.week.ago.round)).
      order(updated_at: :asc).to_sql

    assert_equal Reservation.current_week_revenue(user).to_sql, expected_sql
  end

  should "reject reservation if room is not available" do
    existing_reservation = reservations(:rescue_leia)
    new_reservation = existing_reservation.dup

    assert_difference "new_reservation.errors[:datetime].size" do
      new_reservation.valid?
    end
  end

  should "accept reservation if room is available" do
    existing_reservation = reservations(:rescue_leia)
    new_reservation = existing_reservation.dup

    new_reservation.datetime = new_reservation.datetime + 1.day

    assert_no_difference "new_reservation.errors[:datetime].size" do
      new_reservation.valid?
    end
  end

  should "save reservation and create notification" do
    reservation = reservations(:rescue_leia).dup
    reservation.datetime = reservation.datetime + 1.day

    assert_difference "Notification.count" do
      reservation.save_and_notify
    end
  end

  should "display reservation time" do
    reservation = reservations(:rescue_leia)
    reservation.datetime = DateTime.new(2099, 12, 31, 10)

    assert_equal "10:00", reservation.time
  end
end
