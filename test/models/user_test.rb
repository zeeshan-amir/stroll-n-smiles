require "test_helper"

class UserTest < ActiveSupport::TestCase
  should have_one(:setting)
  should have_many(:rooms).dependent(:destroy)
  should have_many(:reservations).dependent(:destroy)
  should have_many(:notifications).dependent(:destroy)

  should have_many(:sender_conversations).
    class_name("Conversation").
    with_foreign_key(:sender_id).
    inverse_of(:sender).
    dependent(:nullify)

  should have_many(:recipient_conversations).
    class_name("Conversation").
    with_foreign_key(:recipient_id).
    inverse_of(:recipient).
    dependent(:nullify)

  should have_many(:reviews_as_guest).
    class_name("GuestReview").
    with_foreign_key(:guest_id).
    inverse_of(:guest).
    dependent(:destroy)

  should have_many(:reviews_as_host).
    class_name("HostReview").
    with_foreign_key(:host_id).
    inverse_of(:host).
    dependent(:destroy)

  should validate_presence_of(:fullname)
  should validate_length_of(:fullname).is_at_most(50)
  should validate_uniqueness_of(:phone_number).allow_nil

  should "create setting after create" do
    assert_difference "Setting.count" do
      User.create(
        email: "greedo@strollnsmile",
        password: "hanshotfirst",
        fullname: "Greedo Tetsu, Jr.",
        confirmed_at: Time.now.utc,
      )
    end
  end

  should "allow login with omniauth" do
    expected_email = users(:palpatine).email
    auth_stub = OpenStruct.new(info: OpenStruct.new(email: expected_email))

    assert_equal expected_email, User.from_omniauth(auth_stub).email
  end

  should "allow signup with omniauth" do
    expected_email = "tk421@strollnsmile.com"
    auth_stub = OpenStruct.new(
      info: OpenStruct.new(
        email: expected_email,
        name: "Stormtrooper TK-421",
      ),
      uid: "MSE-6-G735Y",
      provider: "imperial_fleet",
    )

    assert_equal expected_email, User.from_omniauth(auth_stub).email
  end

  should "find guest reviews for user (as host)" do
    user = users(:luke)

    expected_sql = GuestReview.where(host_id: user.id).to_sql

    assert_equal expected_sql, user.guest_reviews.to_sql
  end

  should "find host reviews for user (as guest)" do
    user = users(:luke)

    expected_sql = HostReview.where(guest_id: user.id).to_sql

    assert_equal expected_sql, user.host_reviews.to_sql
  end

  should "generate secure pin for phone verification" do
    user = users(:yoda)

    assert_nil user.pin

    user.generate_pin

    assert_not_nil user.pin
    assert_not user.phone_verified
  end

  should "send message with pin to phone number" do
    user = users(:yoda)

    SendSms.stub(:call, true) do
      assert user.send_pin
    end
  end

  should "verify phone with correct pin" do
    user = users(:yoda)

    user.generate_pin
    user.verify_pin(user.pin)

    assert user.phone_verified
  end

  should "not verify phone with incorrect pin" do
    user = users(:yoda)

    user.generate_pin
    user.verify_pin("900")

    assert_not user.phone_verified
  end

  should "have active host if it has merchant id" do
    user = users(:anakin)
    user.merchant_id = "DS-1"

    assert user.active_host?
  end

  should "not have active host if it doesn't have merchant id" do
    user = users(:anakin)

    assert_not user.active_host?
  end

  should "receive email" do
    user = users(:palpatine)

    assert user.email_enabled?
  end

  should "not receive email when email is disabled" do
    user = users(:palpatine)
    user.setting.enable_email = false

    assert_not user.email_enabled?
  end

  should "receive SMS" do
    user = users(:palpatine)

    assert user.sms_enabled?
  end

  should "not receive SMS when SMS is disabled" do
    user = users(:palpatine)
    user.setting.enable_sms = false

    assert_not user.sms_enabled?
  end

  should "not receive SMS when phone is not verified" do
    user = users(:palpatine)
    user.phone_verified = false

    assert_not user.sms_enabled?
  end
end
