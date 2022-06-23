require "test_helper"

class NotifyReservationApprovalTest < ActionDispatch::IntegrationTest
  setup do
    @reservation = reservations(:rescue_leia)
    @sms_mock = Minitest::Mock.new
    @sms_mock.expect(:call, true, [Hash])
  end

  should "send email to guest and sms to host" do
    SendSms.stub(:call, @sms_mock) do
      assert_emails(1) do
        NotifyReservationApproval.call(@reservation)
      end
    end

    @sms_mock.verify
  end

  should "not send email to guest when guest email is not enabled" do
    @reservation.user.setting.enable_email = false

    SendSms.stub(:call, @sms_mock) do
      assert_emails(0) do
        NotifyReservationApproval.call(@reservation)
      end
    end

    @sms_mock.verify
  end

  should "not send SMS to host when host SMS is not enabled" do
    @reservation.room.user.setting.enable_sms = false

    SendSms.stub(:call, @sms_mock) do
      assert_emails(1) do
        NotifyReservationApproval.call(@reservation)
      end
    end

    assert_raises(MockExpectationError) do
      @sms_mock.verify
    end
  end
end
