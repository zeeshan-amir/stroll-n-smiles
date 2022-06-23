class FakeSms
  def initialize
    @messages_mock = Minitest::Mock.new
    @messages_mock.expect(:create, true, [Hash])

    @twilio_mock = Minitest::Mock.new
    @twilio_mock.expect(:messages, @messages_mock)
  end

  def send(&block)
    Twilio::REST::Client.stub(:new, @twilio_mock, &block)
  end

  def sent?
    @messages_mock.verify
  rescue MockExpectationError
    false
  end
end
