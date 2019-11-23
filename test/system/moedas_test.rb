require "application_system_test_case"

class MoedasTest < ApplicationSystemTestCase
  setup do
    @moeda = moedas(:one)
  end

  test "visiting the index" do
    visit moedas_url
    assert_selector "h1", text: "Moedas"
  end

  test "creating a Moeda" do
    visit moedas_url
    click_on "New Moeda"

    fill_in "Codigo iso", with: @moeda.codigo_iso
    fill_in "Country", with: @moeda.country_id
    fill_in "Nome", with: @moeda.nome
    fill_in "Simbolo", with: @moeda.simbolo
    click_on "Create Moeda"

    assert_text "Moeda was successfully created"
    click_on "Back"
  end

  test "updating a Moeda" do
    visit moedas_url
    click_on "Edit", match: :first

    fill_in "Codigo iso", with: @moeda.codigo_iso
    fill_in "Country", with: @moeda.country_id
    fill_in "Nome", with: @moeda.nome
    fill_in "Simbolo", with: @moeda.simbolo
    click_on "Update Moeda"

    assert_text "Moeda was successfully updated"
    click_on "Back"
  end

  test "destroying a Moeda" do
    visit moedas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Moeda was successfully destroyed"
  end
end
