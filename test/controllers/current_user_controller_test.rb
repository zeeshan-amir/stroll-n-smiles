require "test_helper"

class CurrentUserControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:rey)
  end

  should "redirect when not logged in" do
    sign_out :user

    post verify_phone_number_url

    assert_response :redirect
  end

  should "update user phone number" do
    FakeSms.new.send do
      patch update_phone_number_url(user: { phone_number: "5555555555" })
    end

    assert_equal "Saved...", flash[:notice]
    assert_redirected_to edit_user_registration_url
  end

  should "verify user phone number when correct pin is provided" do
    pin = users(:rey).pin

    post verify_phone_number_url(user: { pin: pin })

    assert_equal "Your phone number is verified.", flash[:notice]
    assert_redirected_to edit_user_registration_url
  end

  should "not verify user phone number when incorrect pin is provided" do
    post verify_phone_number_url(user: { pin: "incorrect pin" })

    assert_equal "Cannot verify your phone number.", flash[:alert]
    assert_redirected_to edit_user_registration_url
  end
end
