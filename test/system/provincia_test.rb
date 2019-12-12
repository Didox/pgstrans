require "application_system_test_case"

class ProvinciaTest < ApplicationSystemTestCase
  setup do
    @provincium = provincia(:one)
  end

  test "visiting the index" do
    visit provincia_url
    assert_selector "h1", text: "Provincia"
  end

  test "creating a Provincium" do
    visit provincia_url
    click_on "New Provincium"

    fill_in "Area km2", with: @provincium.area_km2
    fill_in "Capital", with: @provincium.capital
    fill_in "Country", with: @provincium.country_id
    fill_in "Image map", with: @provincium.image_map
    fill_in "Nome", with: @provincium.nome
    fill_in "Population", with: @provincium.population
    click_on "Create Provincium"

    assert_text "Provincium foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Provincium" do
    visit provincia_url
    click_on "Edit", match: :first

    fill_in "Area km2", with: @provincium.area_km2
    fill_in "Capital", with: @provincium.capital
    fill_in "Country", with: @provincium.country_id
    fill_in "Image map", with: @provincium.image_map
    fill_in "Nome", with: @provincium.nome
    fill_in "Population", with: @provincium.population
    click_on "Update Provincium"

    assert_text "Provincium foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Provincium" do
    visit provincia_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Provincium foi apagado com sucesso"
  end
end
