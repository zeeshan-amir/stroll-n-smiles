require "test_helper"

module Suppliers
  class RoomsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in users(:luke)
    end

    should "redirect when not logged in" do
      sign_out :user

      get suppliers_rooms_url

      assert_response :redirect
    end

    should "redirect when not a supplier (has no clinics)" do
      sign_in users(:rey)

      get suppliers_rooms_url

      assert_response :redirect
    end

    should "get index" do
      get suppliers_rooms_url

      assert_response :success
    end

    should "get new" do
      get new_suppliers_room_url

      assert_response :success
    end

    should "create room" do
      assert_difference("Room.count") do
        post suppliers_rooms_url, params: {
          room: {
            name: "Naboo Queen Restaurant",
            address: "Senate Apartment Complex, Galactic City, Coruscant",
            summary: "Former Padmé Amidala's aparment, now galactic restaurant",
            price: 100,
            payment_methods: %w[Visa MasterCard],
            open_hours: "Mon to Fri: 8am to 10pm, Sat & Sun: 10am to 8pm",
            user: users(:anakin),
          },
        }
      end

      assert_equal "Saved...", flash[:notice]
      assert_redirected_to open_hours_suppliers_room_url(Room.last)
    end

    should "update room owned by user" do
      patch suppliers_room_url(rooms(:first_jedi_temple)), params: {
        room: { name: "Ahch-To Jedi Temple" },
      }

      assert_equal "Saved...", flash[:notice]
      assert_redirected_to request.referer || root_url
    end

    should "not update room not owned by user" do
      patch suppliers_room_url(rooms(:garbage_compactor)), params: {
        room: { name: "Garbage compressor" },
      }

      assert_equal "You don't have permission", flash[:alert]
      assert_redirected_to root_url
    end

    should "edit room sections" do
      room = rooms(:first_jedi_temple)

      get description_suppliers_room_url(room)
      assert_response :success

      get amenities_suppliers_room_url(room)
      assert_response :success

      get pricing_suppliers_room_url(room)
      assert_response :success

      get location_suppliers_room_url(room)
      assert_response :success

      get open_hours_suppliers_room_url(room)
      assert_response :success

      get photo_upload_suppliers_room_url(room)
      assert_response :success
    end
  end
end
