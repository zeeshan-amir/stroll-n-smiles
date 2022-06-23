require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  should "show active room" do
    get room_url(rooms(:garbage_compactor))

    assert_response :success
  end

  should "show inactive room to owner" do
    sign_in users(:han)

    get room_url(rooms(:cantina))

    assert_response :success
  end

  should "not show inactive room to public users" do
    get room_url(rooms(:cantina))

    assert_response :redirect
  end

  should "get room availability as json" do
    get availability_room_url(rooms(:garbage_compactor), date: "2020-01-01")

    assert_equal "application/json", @response.media_type
    assert_response :success
  end
end
