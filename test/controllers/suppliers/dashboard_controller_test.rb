require "test_helper"

module Suppliers
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    should "redirect when not logged in" do
      get suppliers_dashboard_url

      assert_response :redirect
    end

    should "redirect when not a supplier (has no clinics)" do
      sign_in users(:rey)

      get suppliers_dashboard_url

      assert_response :redirect
    end

    should "get index" do
      sign_in users(:luke)

      get suppliers_dashboard_url

      assert_response :success
    end
  end
end
