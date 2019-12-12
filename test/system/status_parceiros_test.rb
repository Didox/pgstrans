require "application_system_test_case"

class StatusParceirosTest < ApplicationSystemTestCase
  setup do
    @status_parceiro = status_parceiros(:one)
  end

  test "visiting the index" do
    visit status_parceiros_url
    assert_selector "h1", text: "Status Parceiros"
  end

  test "creating a Status parceiro" do
    visit status_parceiros_url
    click_on "New Status Parceiro"

    fill_in "Nome", with: @status_parceiro.nome
    click_on "Create Status parceiro"

    assert_text "Status parceiro was successfully created"
    click_on "Back"
  end

  test "updating a Status parceiro" do
    visit status_parceiros_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @status_parceiro.nome
    click_on "Update Status parceiro"

    assert_text "Status parceiro was successfully updated"
    click_on "Back"
  end

  test "destroying a Status parceiro" do
    visit status_parceiros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status parceiro was successfully destroyed"
  end
end
