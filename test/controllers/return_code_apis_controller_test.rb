require 'test_helper'

class ReturnCodeApisControllerTest < ActionDispatch::IntegrationTest
  setup do
    @return_code_api = return_code_apis(:one)
  end

  test "should get index" do
    get return_code_apis_url
    assert_response :success
  end

  test "should get new" do
    get new_return_code_api_url
    assert_response :success
  end

  test "should create return_code_api" do
    assert_difference('ReturnCodeApi.count') do
      post return_code_apis_url, params: { return_code_api: { error_description: @return_code_api.error_description, error_description_pt: @return_code_api.error_description_pt, return_code: @return_code_api.return_code, return_description: @return_code_api.return_description } }
    end

    assert_redirected_to return_code_api_url(ReturnCodeApi.last)
  end

  test "should show return_code_api" do
    get return_code_api_url(@return_code_api)
    assert_response :success
  end

  test "should get edit" do
    get edit_return_code_api_url(@return_code_api)
    assert_response :success
  end

  test "should update return_code_api" do
    patch return_code_api_url(@return_code_api), params: { return_code_api: { error_description: @return_code_api.error_description, error_description_pt: @return_code_api.error_description_pt, return_code: @return_code_api.return_code, return_description: @return_code_api.return_description } }
    assert_redirected_to return_code_api_url(@return_code_api)
  end

  test "should destroy return_code_api" do
    assert_difference('ReturnCodeApi.count', -1) do
      delete return_code_api_url(@return_code_api)
    end

    assert_redirected_to return_code_apis_url
  end
end
