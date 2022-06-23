require "test_helper"

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:luke)
  end

  should "redirect when not logged in" do
    sign_out :user

    get reservations_url

    assert_response :redirect
  end

  should "get index" do
    get reservations_url

    assert_response :success
  end

  should "create reservation when room is available" do
    room = rooms(:first_jedi_temple)

    assert_difference("Reservation.count") do
      assert_difference("Notification.count") do
        post room_reservations_url(room), params: {
          reservation: { datetime: "2020-01-01", time: "10:00" },
        }
      end
    end

    assert_equal "Request sent successfully!", flash[:notice]
    assert_redirected_to room_url(room)
  end

  should "not create reservation when room is not available" do
    reservation = reservations(:rescue_leia)
    datetime, time = reservation.datetime.to_s.split(" ")

    assert_no_difference("Reservation.count") do
      assert_no_difference("Notification.count") do
        post room_reservations_url(reservation.room), params: {
          reservation: { datetime: datetime, time: time },
        }
      end
    end

    assert_not_empty flash[:alert]
    assert_redirected_to room_url(reservation.room)
  end
end
