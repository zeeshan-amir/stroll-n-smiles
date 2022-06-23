require "test_helper"

module OpenHours
  class SpecialDayTest < ActiveSupport::TestCase
    should belong_to(:room)

    should validate_presence_of(:day)
    should validate_presence_of(:month)
    should validate_numericality_of(:day).only_integer
    should validate_numericality_of(:month).only_integer

    should "be valid when open is null and day/room is not active" do
      open_hours = OpenHours::SpecialDay.new(
        day: 12,
        month: 12,
        open: "08:00",
        room: rooms(:garbage_compactor),
      )

      assert open_hours.valid?
    end

    should "be valid when close is null and day/room is not active" do
      open_hours = OpenHours::SpecialDay.new(
        day: 12,
        month: 12,
        close: "08:00",
        room: rooms(:garbage_compactor),
      )

      assert open_hours.valid?
    end

    should "not be valid when open is null and day/room is active" do
      open_hours = open_hours_special_days(:may_fourth_morning).dup
      open_hours.open = nil

      assert_not open_hours.valid?
    end

    should "not be valid when close is null and day/room is active" do
      open_hours = open_hours_special_days(:may_fourth_morning).dup
      open_hours.close = nil

      assert_not open_hours.valid?
    end

    should "accept valid open and close times" do
      open_hours = open_hours_special_days(:may_fourth_morning)

      assert open_hours.valid?
    end

    should "not allow open to be greater than close" do
      open_hours = open_hours_special_days(:may_fourth_morning)
      open_hours.open = open_hours.close + 1.hour

      assert_not open_hours.valid?
    end

    should "not allow open and close to be equal" do
      open_hours = open_hours_special_days(:may_fourth_morning)
      open_hours.close = open_hours.open

      assert_not open_hours.valid?
    end

    should "not allow overlapping hours" do
      open_hours = open_hours_special_days(:may_fourth_morning).dup

      assert_not open_hours.valid?
    end

    should "not consider own hours as overlapping hours" do
      open_hours = open_hours_special_days(:may_fourth_morning)

      assert open_hours.valid?
    end

    should "find open hours for specified schedule (week, day, open, close)" do
      open_hours = OpenHours::SpecialDay.find_overlaps(
        day: 4,
        month: 5,
        open: "08:00",
        close: "15:00",
      )

      assert_equal 1, open_hours.size

      open_hours = OpenHours::SpecialDay.find_overlaps(
        day: 4,
        month: 5,
        open: "08:00",
        close: "15:30",
      )

      assert_equal 2, open_hours.size
    end

    should "find open hours for specified date" do
      open_hours = OpenHours::SpecialDay.on(Date.new(Date.today.year, 5, 4))

      assert_equal 2, open_hours.size
    end
  end
end
