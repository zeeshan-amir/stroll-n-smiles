require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_presence_of(:plan)
  should validate_length_of(:message).is_at_most(255)

  should "have virtual attribute name" do
    reservation = Subscription.new

    assert_respond_to(reservation, :name)
    assert_respond_to(reservation, :name=)
  end

  should "have virtual attribute email" do
    reservation = Subscription.new

    assert_respond_to(reservation, :email)
    assert_respond_to(reservation, :email=)
  end

  should "have virtual attribute plan" do
    reservation = Subscription.new

    assert_respond_to(reservation, :plan)
    assert_respond_to(reservation, :plan=)
  end

  should "have virtual attribute message" do
    reservation = Subscription.new

    assert_respond_to(reservation, :message)
    assert_respond_to(reservation, :message=)
  end
end
