require "application_system_test_case"

class TopupRecargasTest < ApplicationSystemTestCase
  setup do
    @topup_recarga = topup_recargas(:one)
  end

  test "visiting the index" do
    visit topup_recargas_url
    assert_selector "h1", text: "Topup Recargas"
  end

  test "creating a Topup recarga" do
    visit topup_recargas_url
    click_on "New Topup Recarga"

    fill_in "Attribute element", with: @topup_recarga.attribute_element
    fill_in "Attribute name", with: @topup_recarga.attribute_name
    fill_in "Attribute value", with: @topup_recarga.attribute_value
    fill_in "Attributes list", with: @topup_recarga.attributes_list
    fill_in "Body element", with: @topup_recarga.body_element
    fill_in "Body input message", with: @topup_recarga.body_input_message
    fill_in "Body req element", with: @topup_recarga.body_req_element
    fill_in "Body topup req body amount", with: @topup_recarga.body_topup_req_body_amount
    fill_in "Body topup req body msisdn", with: @topup_recarga.body_topup_req_body_msisdn
    fill_in "Body topup req body type", with: @topup_recarga.body_topup_req_body_type
    fill_in "Credentials element", with: @topup_recarga.credentials_element
    fill_in "Credentials password", with: @topup_recarga.credentials_password
    fill_in "Credentials user", with: @topup_recarga.credentials_user
    fill_in "Header element", with: @topup_recarga.header_element
    fill_in "Header source system", with: @topup_recarga.header_source_system
    fill_in "Header timestamp", with: @topup_recarga.header_timestamp
    fill_in "Od header element", with: @topup_recarga.od_header_element
    fill_in "Od topup resp input message", with: @topup_recarga.od_topup_resp_input_message
    fill_in "Request", with: @topup_recarga.request_id
    fill_in "Topup req header", with: @topup_recarga.topup_req_header
    fill_in "Validation", with: @topup_recarga.validation_id
    click_on "Create Topup recarga"

    assert_text "Topup recarga foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Topup recarga" do
    visit topup_recargas_url
    click_on "Edit", match: :first

    fill_in "Attribute element", with: @topup_recarga.attribute_element
    fill_in "Attribute name", with: @topup_recarga.attribute_name
    fill_in "Attribute value", with: @topup_recarga.attribute_value
    fill_in "Attributes list", with: @topup_recarga.attributes_list
    fill_in "Body element", with: @topup_recarga.body_element
    fill_in "Body input message", with: @topup_recarga.body_input_message
    fill_in "Body req element", with: @topup_recarga.body_req_element
    fill_in "Body topup req body amount", with: @topup_recarga.body_topup_req_body_amount
    fill_in "Body topup req body msisdn", with: @topup_recarga.body_topup_req_body_msisdn
    fill_in "Body topup req body type", with: @topup_recarga.body_topup_req_body_type
    fill_in "Credentials element", with: @topup_recarga.credentials_element
    fill_in "Credentials password", with: @topup_recarga.credentials_password
    fill_in "Credentials user", with: @topup_recarga.credentials_user
    fill_in "Header element", with: @topup_recarga.header_element
    fill_in "Header source system", with: @topup_recarga.header_source_system
    fill_in "Header timestamp", with: @topup_recarga.header_timestamp
    fill_in "Od header element", with: @topup_recarga.od_header_element
    fill_in "Od topup resp input message", with: @topup_recarga.od_topup_resp_input_message
    fill_in "Request", with: @topup_recarga.request_id
    fill_in "Topup req header", with: @topup_recarga.topup_req_header
    fill_in "Validation", with: @topup_recarga.validation_id
    click_on "Update Topup recarga"

    assert_text "Topup recarga foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Topup recarga" do
    visit topup_recargas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Topup recarga foi apagado com sucesso"
  end
end
