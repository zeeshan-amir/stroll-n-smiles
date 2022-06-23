require "test_helper"

module OpenHours
  class SpecialDaysControllerTest < ActionDispatch::IntegrationTest
    should "create open hours when params are valid" do
      assert_difference("OpenHours::SpecialDay.count") do
        post open_hours_special_days_url, params: {
          day: 7,
          month: 7,
          open: "08:00",
          close: "20:00",
          room_id: rooms(:garbage_compactor).id,
        }
      end

      assert_response :success
    end

    should "not create open hours when params are not valid" do
      assert_no_difference("OpenHours::SpecialDay.count") do
        post open_hours_special_days_url, params: {
          day: 7,
          month: 7,
          open: "08:00",
          close: "20:00",
        }
      end

      assert_response :unprocessable_entity
    end

    should "update open hours when params are valid" do
      open_hours = open_hours_special_days(:may_fourth_morning)

      assert_changes("OpenHours::SpecialDay.find(#{open_hours.id}).open") do
        patch open_hours_special_day_url(open_hours), params: {
          open: "10:00",
          close: "12:00",
        }
      end

      assert_response :success
    end

    should "not update open hours when params are not valid" do
      open_hours = open_hours_special_days(:may_fourth_morning)

      assert_no_changes("OpenHours::SpecialDay.find(#{open_hours.id}).open") do
        patch open_hours_special_day_url(open_hours), params: {
          open: "10:00",
          close: "10:00",
        }
      end

      assert_response :unprocessable_entity
    end

    should "delete open hours" do
      open_hours = open_hours_special_days(:may_fourth_morning)

      delete open_hours_special_day_url(open_hours)

      assert_raises(ActiveRecord::RecordNotFound) do
        OpenHours::SpecialDay.find(open_hours.id)
      end

      assert_response :success
    end
  end
end
