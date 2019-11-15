require 'test_helper'

class TopupValidationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @topup_validation = topup_validations(:one)
  end

  test "should get index" do
    get topup_validations_url
    assert_response :success
  end

  test "should get new" do
    get new_topup_validation_url
    assert_response :success
  end

  test "should create topup_validation" do
    assert_difference('TopupValidation.count') do
      post topup_validations_url, params: { topup_validation: { attribute_name: @topup_validation.attribute_name, attribute_value: @topup_validation.attribute_value, attributes_element: @topup_validation.attributes_element, attributes_list: @topup_validation.attributes_list, body_element: @topup_validation.body_element, credentials_element: @topup_validation.credentials_element, credentials_password: @topup_validation.credentials_password, credentials_user: @topup_validation.credentials_user, header_element: @topup_validation.header_element, header_source_system: @topup_validation.header_source_system, header_timestamp: @topup_validation.header_timestamp, op_body_element: @topup_validation.op_body_element, op_body_validate_topup_output_message: @topup_validation.op_body_validate_topup_output_message, op_body_validate_topup_resp: @topup_validation.op_body_validate_topup_resp, op_header: @topup_validation.op_header, op_request_id: @topup_validation.op_request_id, op_return_code: @topup_validation.op_return_code, op_return_message: @topup_validation.op_return_message, op_timestamp: @topup_validation.op_timestamp, op_validate_topup_input_message: @topup_validation.op_validate_topup_input_message, qtde_retry: @topup_validation.qtde_retry, request_id: @topup_validation.request_id, spree_order_id: @topup_validation.spree_order_id, spree_products_id: @topup_validation.spree_products_id, validate_topup_input_message: @topup_validation.validate_topup_input_message, validate_topup_req_body_amount: @topup_validation.validate_topup_req_body_amount, validate_topup_req_body_msisdn: @topup_validation.validate_topup_req_body_msisdn, validate_topup_req_body_type: @topup_validation.validate_topup_req_body_type, validate_topup_req_header_element: @topup_validation.validate_topup_req_header_element, validation_topup_req: @topup_validation.validation_topup_req } }
    end

    assert_redirected_to topup_validation_url(TopupValidation.last)
  end

  test "should show topup_validation" do
    get topup_validation_url(@topup_validation)
    assert_response :success
  end

  test "should get edit" do
    get edit_topup_validation_url(@topup_validation)
    assert_response :success
  end

  test "should update topup_validation" do
    patch topup_validation_url(@topup_validation), params: { topup_validation: { attribute_name: @topup_validation.attribute_name, attribute_value: @topup_validation.attribute_value, attributes_element: @topup_validation.attributes_element, attributes_list: @topup_validation.attributes_list, body_element: @topup_validation.body_element, credentials_element: @topup_validation.credentials_element, credentials_password: @topup_validation.credentials_password, credentials_user: @topup_validation.credentials_user, header_element: @topup_validation.header_element, header_source_system: @topup_validation.header_source_system, header_timestamp: @topup_validation.header_timestamp, op_body_element: @topup_validation.op_body_element, op_body_validate_topup_output_message: @topup_validation.op_body_validate_topup_output_message, op_body_validate_topup_resp: @topup_validation.op_body_validate_topup_resp, op_header: @topup_validation.op_header, op_request_id: @topup_validation.op_request_id, op_return_code: @topup_validation.op_return_code, op_return_message: @topup_validation.op_return_message, op_timestamp: @topup_validation.op_timestamp, op_validate_topup_input_message: @topup_validation.op_validate_topup_input_message, qtde_retry: @topup_validation.qtde_retry, request_id: @topup_validation.request_id, spree_order_id: @topup_validation.spree_order_id, spree_products_id: @topup_validation.spree_products_id, validate_topup_input_message: @topup_validation.validate_topup_input_message, validate_topup_req_body_amount: @topup_validation.validate_topup_req_body_amount, validate_topup_req_body_msisdn: @topup_validation.validate_topup_req_body_msisdn, validate_topup_req_body_type: @topup_validation.validate_topup_req_body_type, validate_topup_req_header_element: @topup_validation.validate_topup_req_header_element, validation_topup_req: @topup_validation.validation_topup_req } }
    assert_redirected_to topup_validation_url(@topup_validation)
  end

  test "should destroy topup_validation" do
    assert_difference('TopupValidation.count', -1) do
      delete topup_validation_url(@topup_validation)
    end

    assert_redirected_to topup_validations_url
  end
end
