require "application_system_test_case"

class TopupValidationsTest < ApplicationSystemTestCase
  setup do
    @topup_validation = topup_validations(:one)
  end

  test "visiting the index" do
    visit topup_validations_url
    assert_selector "h1", text: "Topup Validations"
  end

  test "creating a Topup validation" do
    visit topup_validations_url
    click_on "New Topup Validation"

    fill_in "Attribute name", with: @topup_validation.attribute_name
    fill_in "Attribute value", with: @topup_validation.attribute_value
    fill_in "Attributes element", with: @topup_validation.attributes_element
    fill_in "Attributes list", with: @topup_validation.attributes_list
    fill_in "Body element", with: @topup_validation.body_element
    fill_in "Credentials element", with: @topup_validation.credentials_element
    fill_in "Credentials password", with: @topup_validation.credentials_password
    fill_in "Credentials user", with: @topup_validation.credentials_user
    fill_in "Header element", with: @topup_validation.header_element
    fill_in "Header source system", with: @topup_validation.header_source_system
    fill_in "Header timestamp", with: @topup_validation.header_timestamp
    fill_in "Op body element", with: @topup_validation.op_body_element
    fill_in "Op body validate topup output message", with: @topup_validation.op_body_validate_topup_output_message
    fill_in "Op body validate topup resp", with: @topup_validation.op_body_validate_topup_resp
    fill_in "Op header", with: @topup_validation.op_header
    fill_in "Op request", with: @topup_validation.op_request_id
    fill_in "Op return code", with: @topup_validation.op_return_code
    fill_in "Op return message", with: @topup_validation.op_return_message
    fill_in "Op timestamp", with: @topup_validation.op_timestamp
    fill_in "Op validate topup input message", with: @topup_validation.op_validate_topup_input_message
    fill_in "Qtde retry", with: @topup_validation.qtde_retry
    fill_in "Request", with: @topup_validation.request_id
    fill_in "Spree order", with: @topup_validation.spree_order_id
    fill_in "Spree products", with: @topup_validation.spree_products_id
    fill_in "Validate topup input message", with: @topup_validation.validate_topup_input_message
    fill_in "Validate topup req body amount", with: @topup_validation.validate_topup_req_body_amount
    fill_in "Validate topup req body msisdn", with: @topup_validation.validate_topup_req_body_msisdn
    fill_in "Validate topup req body type", with: @topup_validation.validate_topup_req_body_type
    fill_in "Validate topup req header element", with: @topup_validation.validate_topup_req_header_element
    fill_in "Validation topup req", with: @topup_validation.validation_topup_req
    click_on "Create Topup validation"

    assert_text "Topup validation was successfully created"
    click_on "Back"
  end

  test "updating a Topup validation" do
    visit topup_validations_url
    click_on "Edit", match: :first

    fill_in "Attribute name", with: @topup_validation.attribute_name
    fill_in "Attribute value", with: @topup_validation.attribute_value
    fill_in "Attributes element", with: @topup_validation.attributes_element
    fill_in "Attributes list", with: @topup_validation.attributes_list
    fill_in "Body element", with: @topup_validation.body_element
    fill_in "Credentials element", with: @topup_validation.credentials_element
    fill_in "Credentials password", with: @topup_validation.credentials_password
    fill_in "Credentials user", with: @topup_validation.credentials_user
    fill_in "Header element", with: @topup_validation.header_element
    fill_in "Header source system", with: @topup_validation.header_source_system
    fill_in "Header timestamp", with: @topup_validation.header_timestamp
    fill_in "Op body element", with: @topup_validation.op_body_element
    fill_in "Op body validate topup output message", with: @topup_validation.op_body_validate_topup_output_message
    fill_in "Op body validate topup resp", with: @topup_validation.op_body_validate_topup_resp
    fill_in "Op header", with: @topup_validation.op_header
    fill_in "Op request", with: @topup_validation.op_request_id
    fill_in "Op return code", with: @topup_validation.op_return_code
    fill_in "Op return message", with: @topup_validation.op_return_message
    fill_in "Op timestamp", with: @topup_validation.op_timestamp
    fill_in "Op validate topup input message", with: @topup_validation.op_validate_topup_input_message
    fill_in "Qtde retry", with: @topup_validation.qtde_retry
    fill_in "Request", with: @topup_validation.request_id
    fill_in "Spree order", with: @topup_validation.spree_order_id
    fill_in "Spree products", with: @topup_validation.spree_products_id
    fill_in "Validate topup input message", with: @topup_validation.validate_topup_input_message
    fill_in "Validate topup req body amount", with: @topup_validation.validate_topup_req_body_amount
    fill_in "Validate topup req body msisdn", with: @topup_validation.validate_topup_req_body_msisdn
    fill_in "Validate topup req body type", with: @topup_validation.validate_topup_req_body_type
    fill_in "Validate topup req header element", with: @topup_validation.validate_topup_req_header_element
    fill_in "Validation topup req", with: @topup_validation.validation_topup_req
    click_on "Update Topup validation"

    assert_text "Topup validation was successfully updated"
    click_on "Back"
  end

  test "destroying a Topup validation" do
    visit topup_validations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Topup validation was successfully destroyed"
  end
end
