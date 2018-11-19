require 'test_helper'

class NewControllerTest < ActionDispatch::IntegrationTest
  test "should get score" do
    get new_score_url
    assert_response :success
  end

end
