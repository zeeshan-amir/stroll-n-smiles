require "test_helper"

class CalendarTest < ActiveSupport::TestCase
  should define_enum_for(:status).with_values(available: 0, not_available: 1)

  should belong_to(:room)

  should validate_presence_of(:day)
end
