require "application_system_test_case"

class ReturnCodeApisTest < ApplicationSystemTestCase
  setup do
    @return_code_api = return_code_apis(:one)
  end

  test "visiting the index" do
    visit return_code_apis_url
    assert_selector "h1", text: "Return Code Apis"
  end

  test "creating a Return code api" do
    visit return_code_apis_url
    click_on "New Return Code Api"

    fill_in "Error description", with: @return_code_api.error_description
    fill_in "Error description pt", with: @return_code_api.error_description_pt
    fill_in "Return code", with: @return_code_api.return_code
    fill_in "Return description", with: @return_code_api.return_description
    click_on "Create Return code api"

    assert_text "Return code api was successfully created"
    click_on "Back"
  end

  test "updating a Return code api" do
    visit return_code_apis_url
    click_on "Edit", match: :first

    fill_in "Error description", with: @return_code_api.error_description
    fill_in "Error description pt", with: @return_code_api.error_description_pt
    fill_in "Return code", with: @return_code_api.return_code
    fill_in "Return description", with: @return_code_api.return_description
    click_on "Update Return code api"

    assert_text "Return code api was successfully updated"
    click_on "Back"
  end

  test "destroying a Return code api" do
    visit return_code_apis_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Return code api was successfully destroyed"
  end
end
