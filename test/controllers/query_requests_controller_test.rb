require 'test_helper'

class QueryRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @query_request = query_requests(:one)
  end

  test "should get index" do
    get query_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_query_request_url
    assert_response :success
  end

  test "should create query_request" do
    assert_difference('QueryRequest.count') do
      post query_requests_url, params: { query_request: { attribute_element: @query_request.attribute_element, attribute_name: @query_request.attribute_name, attribute_value: @query_request.attribute_value, attributes_list: @query_request.attributes_list, body_element: @query_request.body_element, body_query_request_id: @query_request.body_query_request_id, body_query_request_input_message: @query_request.body_query_request_input_message, body_query_request_req_element: @query_request.body_query_request_req_element, credentials_element: @query_request.credentials_element, credentials_password: @query_request.credentials_password, credentials_user: @query_request.credentials_user, header_element: @query_request.header_element, header_request_id: @query_request.header_request_id, header_source_system: @query_request.header_source_system, header_timestamp: @query_request.header_timestamp, od_header_element: @query_request.od_header_element, od_query_request_body_element: @query_request.od_query_request_body_element, od_query_request_input_message: @query_request.od_query_request_input_message, od_query_request_output_message: @query_request.od_query_request_output_message, od_query_request_request_id: @query_request.od_query_request_request_id, od_query_request_return_code: @query_request.od_query_request_return_code, od_query_request_return_message: @query_request.od_query_request_return_message, od_query_request_status: @query_request.od_query_request_status, od_query_request_timestamp: @query_request.od_query_request_timestamp, query_request_req_header: @query_request.query_request_req_header } }
    end

    assert_redirected_to query_request_url(QueryRequest.last)
  end

  test "should show query_request" do
    get query_request_url(@query_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_query_request_url(@query_request)
    assert_response :success
  end

  test "should update query_request" do
    patch query_request_url(@query_request), params: { query_request: { attribute_element: @query_request.attribute_element, attribute_name: @query_request.attribute_name, attribute_value: @query_request.attribute_value, attributes_list: @query_request.attributes_list, body_element: @query_request.body_element, body_query_request_id: @query_request.body_query_request_id, body_query_request_input_message: @query_request.body_query_request_input_message, body_query_request_req_element: @query_request.body_query_request_req_element, credentials_element: @query_request.credentials_element, credentials_password: @query_request.credentials_password, credentials_user: @query_request.credentials_user, header_element: @query_request.header_element, header_request_id: @query_request.header_request_id, header_source_system: @query_request.header_source_system, header_timestamp: @query_request.header_timestamp, od_header_element: @query_request.od_header_element, od_query_request_body_element: @query_request.od_query_request_body_element, od_query_request_input_message: @query_request.od_query_request_input_message, od_query_request_output_message: @query_request.od_query_request_output_message, od_query_request_request_id: @query_request.od_query_request_request_id, od_query_request_return_code: @query_request.od_query_request_return_code, od_query_request_return_message: @query_request.od_query_request_return_message, od_query_request_status: @query_request.od_query_request_status, od_query_request_timestamp: @query_request.od_query_request_timestamp, query_request_req_header: @query_request.query_request_req_header } }
    assert_redirected_to query_request_url(@query_request)
  end

  test "should destroy query_request" do
    assert_difference('QueryRequest.count', -1) do
      delete query_request_url(@query_request)
    end

    assert_redirected_to query_requests_url
  end
end
