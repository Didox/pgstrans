require "application_system_test_case"

class QueryRequestsTest < ApplicationSystemTestCase
  setup do
    @query_request = query_requests(:one)
  end

  test "visiting the index" do
    visit query_requests_url
    assert_selector "h1", text: "Query Requests"
  end

  test "creating a Query request" do
    visit query_requests_url
    click_on "New Query Request"

    fill_in "Attribute element", with: @query_request.attribute_element
    fill_in "Attribute name", with: @query_request.attribute_name
    fill_in "Attribute value", with: @query_request.attribute_value
    fill_in "Attributes list", with: @query_request.attributes_list
    fill_in "Body element", with: @query_request.body_element
    fill_in "Body query request", with: @query_request.body_query_request_id
    fill_in "Body query request input message", with: @query_request.body_query_request_input_message
    fill_in "Body query request req element", with: @query_request.body_query_request_req_element
    fill_in "Credentials element", with: @query_request.credentials_element
    fill_in "Credentials password", with: @query_request.credentials_password
    fill_in "Credentials user", with: @query_request.credentials_user
    fill_in "Header element", with: @query_request.header_element
    fill_in "Header request", with: @query_request.header_request_id
    fill_in "Header source system", with: @query_request.header_source_system
    fill_in "Header timestamp", with: @query_request.header_timestamp
    fill_in "Od header element", with: @query_request.od_header_element
    fill_in "Od query request body element", with: @query_request.od_query_request_body_element
    fill_in "Od query request input message", with: @query_request.od_query_request_input_message
    fill_in "Od query request output message", with: @query_request.od_query_request_output_message
    fill_in "Od query request request", with: @query_request.od_query_request_request_id
    fill_in "Od query request return code", with: @query_request.od_query_request_return_code
    fill_in "Od query request return message", with: @query_request.od_query_request_return_message
    fill_in "Od query request status", with: @query_request.od_query_request_status
    fill_in "Od query request timestamp", with: @query_request.od_query_request_timestamp
    fill_in "Query request req header", with: @query_request.query_request_req_header
    click_on "Create Query request"

    assert_text "Query request was successfully created"
    click_on "Back"
  end

  test "updating a Query request" do
    visit query_requests_url
    click_on "Edit", match: :first

    fill_in "Attribute element", with: @query_request.attribute_element
    fill_in "Attribute name", with: @query_request.attribute_name
    fill_in "Attribute value", with: @query_request.attribute_value
    fill_in "Attributes list", with: @query_request.attributes_list
    fill_in "Body element", with: @query_request.body_element
    fill_in "Body query request", with: @query_request.body_query_request_id
    fill_in "Body query request input message", with: @query_request.body_query_request_input_message
    fill_in "Body query request req element", with: @query_request.body_query_request_req_element
    fill_in "Credentials element", with: @query_request.credentials_element
    fill_in "Credentials password", with: @query_request.credentials_password
    fill_in "Credentials user", with: @query_request.credentials_user
    fill_in "Header element", with: @query_request.header_element
    fill_in "Header request", with: @query_request.header_request_id
    fill_in "Header source system", with: @query_request.header_source_system
    fill_in "Header timestamp", with: @query_request.header_timestamp
    fill_in "Od header element", with: @query_request.od_header_element
    fill_in "Od query request body element", with: @query_request.od_query_request_body_element
    fill_in "Od query request input message", with: @query_request.od_query_request_input_message
    fill_in "Od query request output message", with: @query_request.od_query_request_output_message
    fill_in "Od query request request", with: @query_request.od_query_request_request_id
    fill_in "Od query request return code", with: @query_request.od_query_request_return_code
    fill_in "Od query request return message", with: @query_request.od_query_request_return_message
    fill_in "Od query request status", with: @query_request.od_query_request_status
    fill_in "Od query request timestamp", with: @query_request.od_query_request_timestamp
    fill_in "Query request req header", with: @query_request.query_request_req_header
    click_on "Update Query request"

    assert_text "Query request was successfully updated"
    click_on "Back"
  end

  test "destroying a Query request" do
    visit query_requests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Query request was successfully destroyed"
  end
end
