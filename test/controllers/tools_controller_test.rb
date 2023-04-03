require "test_helper"

class ToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get capacity" do
    get tools_capacity_url
    assert_response :success
  end
end
