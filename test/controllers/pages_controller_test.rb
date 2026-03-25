require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get impressum" do
    get pages_impressum_url
    assert_response :success
  end
end
