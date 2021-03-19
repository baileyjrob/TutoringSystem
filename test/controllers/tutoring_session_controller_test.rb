require "test_helper"

class TutoringSessionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tutoring_session_index_url
    assert_response :success
  end
end
