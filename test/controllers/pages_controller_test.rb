require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  should "get home" do
    get root_path

    assert_response :success
  end

  should "get why" do
    get root_path

    assert_response :success
  end

  should "get how it works" do
    get root_path

    assert_response :success
  end

  should "get faq" do
    get root_path

    assert_response :success
  end

  should "get about" do
    get root_path

    assert_response :success
  end

  should "get privacy" do
    get root_path

    assert_response :success
  end

  should "get terms" do
    get root_path

    assert_response :success
  end

  should "get search" do
    get search_path

    assert_response :success
  end
end
