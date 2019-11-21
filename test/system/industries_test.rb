require "application_system_test_case"

class IndustriesTest < ApplicationSystemTestCase
  setup do
    @industry = industries(:one)
  end

  test "visiting the index" do
    visit industries_url
    assert_selector "h1", text: "Industries"
  end

  test "creating a Industry" do
    visit industries_url
    click_on "New Industry"

    fill_in "Descr curta", with: @industry.descr_curta
    fill_in "Descr longa", with: @industry.descr_longa
    click_on "Create Industry"

    assert_text "Industry foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Industry" do
    visit industries_url
    click_on "Edit", match: :first

    fill_in "Descr curta", with: @industry.descr_curta
    fill_in "Descr longa", with: @industry.descr_longa
    click_on "Update Industry"

    assert_text "Industry foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Industry" do
    visit industries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Industry foi apagado com sucesso"
  end
end
