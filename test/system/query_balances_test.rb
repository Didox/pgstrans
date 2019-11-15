require "application_system_test_case"

class QueryBalancesTest < ApplicationSystemTestCase
  setup do
    @query_balance = query_balances(:one)
  end

  test "visiting the index" do
    visit query_balances_url
    assert_selector "h1", text: "Query Balances"
  end

  test "creating a Query balance" do
    visit query_balances_url
    click_on "New Query Balance"

    fill_in "Attribute element", with: @query_balance.attribute_element
    fill_in "Attribute name", with: @query_balance.attribute_name
    fill_in "Attribute value", with: @query_balance.attribute_value
    fill_in "Attributes list", with: @query_balance.attributes_list
    fill_in "Body element", with: @query_balance.body_element
    fill_in "Body query balance input message", with: @query_balance.body_query_balance_input_message
    fill_in "Body query balance req element", with: @query_balance.body_query_balance_req_element
    fill_in "Credentials element", with: @query_balance.credentials_element
    fill_in "Credentials password", with: @query_balance.credentials_password
    fill_in "Credentials user", with: @query_balance.credentials_user
    fill_in "Header element", with: @query_balance.header_element
    fill_in "Header request", with: @query_balance.header_request_id
    fill_in "Header source system", with: @query_balance.header_source_system
    fill_in "Header timestamp", with: @query_balance.header_timestamp
    fill_in "Od header element", with: @query_balance.od_header_element
    fill_in "Od query balance balance", with: @query_balance.od_query_balance_balance
    fill_in "Od query balance body element", with: @query_balance.od_query_balance_body_element
    fill_in "Od query balance input message", with: @query_balance.od_query_balance_input_message
    fill_in "Od query balance output message", with: @query_balance.od_query_balance_output_message
    fill_in "Od query balance request", with: @query_balance.od_query_balance_request_id
    fill_in "Od query balance resp", with: @query_balance.od_query_balance_resp
    fill_in "Od query balance return code", with: @query_balance.od_query_balance_return_code
    fill_in "Od query balance return message", with: @query_balance.od_query_balance_return_message
    fill_in "Od query balance timestamp", with: @query_balance.od_query_balance_timestamp
    fill_in "Query balance req header", with: @query_balance.query_balance_req_header
    click_on "Create Query balance"

    assert_text "Query balance was successfully created"
    click_on "Back"
  end

  test "updating a Query balance" do
    visit query_balances_url
    click_on "Edit", match: :first

    fill_in "Attribute element", with: @query_balance.attribute_element
    fill_in "Attribute name", with: @query_balance.attribute_name
    fill_in "Attribute value", with: @query_balance.attribute_value
    fill_in "Attributes list", with: @query_balance.attributes_list
    fill_in "Body element", with: @query_balance.body_element
    fill_in "Body query balance input message", with: @query_balance.body_query_balance_input_message
    fill_in "Body query balance req element", with: @query_balance.body_query_balance_req_element
    fill_in "Credentials element", with: @query_balance.credentials_element
    fill_in "Credentials password", with: @query_balance.credentials_password
    fill_in "Credentials user", with: @query_balance.credentials_user
    fill_in "Header element", with: @query_balance.header_element
    fill_in "Header request", with: @query_balance.header_request_id
    fill_in "Header source system", with: @query_balance.header_source_system
    fill_in "Header timestamp", with: @query_balance.header_timestamp
    fill_in "Od header element", with: @query_balance.od_header_element
    fill_in "Od query balance balance", with: @query_balance.od_query_balance_balance
    fill_in "Od query balance body element", with: @query_balance.od_query_balance_body_element
    fill_in "Od query balance input message", with: @query_balance.od_query_balance_input_message
    fill_in "Od query balance output message", with: @query_balance.od_query_balance_output_message
    fill_in "Od query balance request", with: @query_balance.od_query_balance_request_id
    fill_in "Od query balance resp", with: @query_balance.od_query_balance_resp
    fill_in "Od query balance return code", with: @query_balance.od_query_balance_return_code
    fill_in "Od query balance return message", with: @query_balance.od_query_balance_return_message
    fill_in "Od query balance timestamp", with: @query_balance.od_query_balance_timestamp
    fill_in "Query balance req header", with: @query_balance.query_balance_req_header
    click_on "Update Query balance"

    assert_text "Query balance was successfully updated"
    click_on "Back"
  end

  test "destroying a Query balance" do
    visit query_balances_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Query balance was successfully destroyed"
  end
end
