require "test_helper"

class SendSmsTest < ActiveSupport::TestCase
  should "send SMS" do
    fake_sms = FakeSms.new

    fake_sms.send do
      SendSms.call(to: "5555555555", body: "Help me, Obi-Wan Kenobi.")
    end

    assert fake_sms.sent?
  end
end
