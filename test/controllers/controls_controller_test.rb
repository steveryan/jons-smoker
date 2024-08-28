require "test_helper"

class ControlsControllerTest < ActionDispatch::IntegrationTest
  test "should get overview" do
    get controls_overview_url
    assert_response :success
  end
end
