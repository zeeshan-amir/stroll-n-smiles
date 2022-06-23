require "test_helper"

module OpenHours
  class WeekDayTest < ActiveSupport::TestCase
    should belong_to(:room)

    should validate_presence_of(:open)
    should validate_presence_of(:close)
    should validate_presence_of(:week_day)
    should define_enum_for(:week_day).
      with_values(
        monday: 1,
        tuesday: 2,
        wednesday: 3,
        thursday: 4,
        friday: 5,
        saturday: 6,
        sunday: 7,
      )

    should "accept valid open and close times" do
      open_hours = open_hours_week_days(:early_meditation)

      assert open_hours.valid?
    end

    should "not allow open to be greater than close" do
      open_hours = open_hours_week_days(:early_meditation)
      open_hours.open = open_hours.close + 1.hour

      assert_not open_hours.valid?
    end

    should "not allow open and close to be equal" do
      open_hours = open_hours_week_days(:early_meditation)
      open_hours.close = open_hours.open

      assert_not open_hours.valid?
    end

    should "not allow overlapping hours" do
      open_hours = open_hours_week_days(:early_meditation).dup

      assert_not open_hours.valid?
    end

    should "not consider own hours as overlapping hours" do
      open_hours = open_hours_week_days(:early_meditation)

      assert open_hours.valid?
    end

    should "find open hours for specified schedule (week_day, open, close)" do
      open_hours = OpenHours::WeekDay.find_overlaps(
        week_day: 7,
        open: "08:00",
        close: "15:00",
      )

      assert_equal 1, open_hours.size

      open_hours = OpenHours::WeekDay.find_overlaps(
        week_day: 7,
        open: "08:00",
        close: "15:30",
      )

      assert_equal 2, open_hours.size
    end

    should "find open hours for specified date" do
      open_hours = OpenHours::WeekDay.on(Date.today.sunday)

      assert_equal 2, open_hours.size
    end
  end
end
