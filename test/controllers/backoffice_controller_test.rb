require 'test_helper'

class BackofficeControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get backoffice_home_url
    assert_response :success
  end

end
