require 'test_helper'

class TopupRecargasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topup_recarga = topup_recargas(:one)
  end

  test "should get index" do
    get topup_recargas_url
    assert_response :success
  end

  test "should get new" do
    get new_topup_recarga_url
    assert_response :success
  end

  test "should create topup_recarga" do
    assert_difference('TopupRecarga.count') do
      post topup_recargas_url, params: { topup_recarga: { attribute_element: @topup_recarga.attribute_element, attribute_name: @topup_recarga.attribute_name, attribute_value: @topup_recarga.attribute_value, attributes_list: @topup_recarga.attributes_list, body_element: @topup_recarga.body_element, body_input_message: @topup_recarga.body_input_message, body_req_element: @topup_recarga.body_req_element, body_topup_req_body_amount: @topup_recarga.body_topup_req_body_amount, body_topup_req_body_msisdn: @topup_recarga.body_topup_req_body_msisdn, body_topup_req_body_type: @topup_recarga.body_topup_req_body_type, credentials_element: @topup_recarga.credentials_element, credentials_password: @topup_recarga.credentials_password, credentials_user: @topup_recarga.credentials_user, header_element: @topup_recarga.header_element, header_source_system: @topup_recarga.header_source_system, header_timestamp: @topup_recarga.header_timestamp, od_header_element: @topup_recarga.od_header_element, od_topup_resp_input_message: @topup_recarga.od_topup_resp_input_message, request_id: @topup_recarga.request_id, topup_req_header: @topup_recarga.topup_req_header, validation_id: @topup_recarga.validation_id } }
    end

    assert_redirected_to topup_recarga_url(TopupRecarga.last)
  end

  test "should show topup_recarga" do
    get topup_recarga_url(@topup_recarga)
    assert_response :success
  end

  test "should get edit" do
    get edit_topup_recarga_url(@topup_recarga)
    assert_response :success
  end

  test "should update topup_recarga" do
    patch topup_recarga_url(@topup_recarga), params: { topup_recarga: { attribute_element: @topup_recarga.attribute_element, attribute_name: @topup_recarga.attribute_name, attribute_value: @topup_recarga.attribute_value, attributes_list: @topup_recarga.attributes_list, body_element: @topup_recarga.body_element, body_input_message: @topup_recarga.body_input_message, body_req_element: @topup_recarga.body_req_element, body_topup_req_body_amount: @topup_recarga.body_topup_req_body_amount, body_topup_req_body_msisdn: @topup_recarga.body_topup_req_body_msisdn, body_topup_req_body_type: @topup_recarga.body_topup_req_body_type, credentials_element: @topup_recarga.credentials_element, credentials_password: @topup_recarga.credentials_password, credentials_user: @topup_recarga.credentials_user, header_element: @topup_recarga.header_element, header_source_system: @topup_recarga.header_source_system, header_timestamp: @topup_recarga.header_timestamp, od_header_element: @topup_recarga.od_header_element, od_topup_resp_input_message: @topup_recarga.od_topup_resp_input_message, request_id: @topup_recarga.request_id, topup_req_header: @topup_recarga.topup_req_header, validation_id: @topup_recarga.validation_id } }
    assert_redirected_to topup_recarga_url(@topup_recarga)
  end

  test "should destroy topup_recarga" do
    assert_difference('TopupRecarga.count', -1) do
      delete topup_recarga_url(@topup_recarga)
    end

    assert_redirected_to topup_recargas_url
  end
end
