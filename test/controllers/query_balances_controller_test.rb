require 'test_helper'

class QueryBalancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @query_balance = query_balances(:one)
  end

  test "should get index" do
    get query_balances_url
    assert_response :success
  end

  test "should get new" do
    get new_query_balance_url
    assert_response :success
  end

  test "should create query_balance" do
    assert_difference('QueryBalance.count') do
      post query_balances_url, params: { query_balance: { attribute_element: @query_balance.attribute_element, attribute_name: @query_balance.attribute_name, attribute_value: @query_balance.attribute_value, attributes_list: @query_balance.attributes_list, body_element: @query_balance.body_element, body_query_balance_input_message: @query_balance.body_query_balance_input_message, body_query_balance_req_element: @query_balance.body_query_balance_req_element, credentials_element: @query_balance.credentials_element, credentials_password: @query_balance.credentials_password, credentials_user: @query_balance.credentials_user, header_element: @query_balance.header_element, header_request_id: @query_balance.header_request_id, header_source_system: @query_balance.header_source_system, header_timestamp: @query_balance.header_timestamp, od_header_element: @query_balance.od_header_element, od_query_balance_balance: @query_balance.od_query_balance_balance, od_query_balance_body_element: @query_balance.od_query_balance_body_element, od_query_balance_input_message: @query_balance.od_query_balance_input_message, od_query_balance_output_message: @query_balance.od_query_balance_output_message, od_query_balance_request_id: @query_balance.od_query_balance_request_id, od_query_balance_resp: @query_balance.od_query_balance_resp, od_query_balance_return_code: @query_balance.od_query_balance_return_code, od_query_balance_return_message: @query_balance.od_query_balance_return_message, od_query_balance_timestamp: @query_balance.od_query_balance_timestamp, query_balance_req_header: @query_balance.query_balance_req_header } }
    end

    assert_redirected_to query_balance_url(QueryBalance.last)
  end

  test "should show query_balance" do
    get query_balance_url(@query_balance)
    assert_response :success
  end

  test "should get edit" do
    get edit_query_balance_url(@query_balance)
    assert_response :success
  end

  test "should update query_balance" do
    patch query_balance_url(@query_balance), params: { query_balance: { attribute_element: @query_balance.attribute_element, attribute_name: @query_balance.attribute_name, attribute_value: @query_balance.attribute_value, attributes_list: @query_balance.attributes_list, body_element: @query_balance.body_element, body_query_balance_input_message: @query_balance.body_query_balance_input_message, body_query_balance_req_element: @query_balance.body_query_balance_req_element, credentials_element: @query_balance.credentials_element, credentials_password: @query_balance.credentials_password, credentials_user: @query_balance.credentials_user, header_element: @query_balance.header_element, header_request_id: @query_balance.header_request_id, header_source_system: @query_balance.header_source_system, header_timestamp: @query_balance.header_timestamp, od_header_element: @query_balance.od_header_element, od_query_balance_balance: @query_balance.od_query_balance_balance, od_query_balance_body_element: @query_balance.od_query_balance_body_element, od_query_balance_input_message: @query_balance.od_query_balance_input_message, od_query_balance_output_message: @query_balance.od_query_balance_output_message, od_query_balance_request_id: @query_balance.od_query_balance_request_id, od_query_balance_resp: @query_balance.od_query_balance_resp, od_query_balance_return_code: @query_balance.od_query_balance_return_code, od_query_balance_return_message: @query_balance.od_query_balance_return_message, od_query_balance_timestamp: @query_balance.od_query_balance_timestamp, query_balance_req_header: @query_balance.query_balance_req_header } }
    assert_redirected_to query_balance_url(@query_balance)
  end

  test "should destroy query_balance" do
    assert_difference('QueryBalance.count', -1) do
      delete query_balance_url(@query_balance)
    end

    assert_redirected_to query_balances_url
  end
end
