require "test_helper"

module Suppliers
  class ReservationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:luke)
    end

    should "redirect when not logged in" do
      sign_out :user

      get suppliers_reservations_url

      assert_response :redirect
    end

    should "redirect when not a supplier (has no clinics)" do
      sign_in users(:rey)

      get suppliers_reservations_url

      assert_response :redirect
    end

    should "get index" do
      get suppliers_reservations_url

      assert_response :success
    end

    should "approve reservation" do
      reservation = reservations(:rescue_leia)
      notification_mock = Minitest::Mock.new
      notification_mock.expect(:call, true, [Reservation])

      NotifyReservationApproval.stub(:call, notification_mock) do
        post approve_suppliers_reservation_url(reservation)
      end

      notification_mock.verify
      assert Reservation.find(reservation.id).approved?
      assert_redirected_to suppliers_reservations_url
    end

    should "decline reservation" do
      reservation = reservations(:rescue_leia)

      post decline_suppliers_reservation_url(reservation)

      assert Reservation.find(reservation.id).declined?
      assert_redirected_to suppliers_reservations_url
    end
  end
end
