require "application_system_test_case"

class CountriesTest < ApplicationSystemTestCase
  setup do
    @country = countries(:one)
  end

  test "visiting the index" do
    visit countries_url
    assert_selector "h1", text: "Countries"
  end

  test "creating a Country" do
    visit countries_url
    click_on "New Country"

    fill_in "Bacen", with: @country.bacen
    fill_in "Iso2", with: @country.iso2
    fill_in "Name eng", with: @country.name_eng
    fill_in "Name pt", with: @country.name_pt
    click_on "Create Country"

    assert_text "Country foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Country" do
    visit countries_url
    click_on "Edit", match: :first

    fill_in "Bacen", with: @country.bacen
    fill_in "Iso2", with: @country.iso2
    fill_in "Name eng", with: @country.name_eng
    fill_in "Name pt", with: @country.name_pt
    click_on "Update Country"

    assert_text "Country was successfully updated"
    click_on "Back"
  end

  test "destroying a Country" do
    visit countries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Country foi apagado com sucesso"
  end
end
