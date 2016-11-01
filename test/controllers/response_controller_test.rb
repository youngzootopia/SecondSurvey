require 'test_helper'

class ResponseControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get response_test_url
    assert_response :success
  end

end
