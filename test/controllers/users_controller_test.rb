require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:luke)
  end

  should "show user" do
    get user_url(users(:yoda))

    assert_response :success
  end
end
