require "application_system_test_case"

class StatusClientesTest < ApplicationSystemTestCase
  setup do
    @status_cliente = status_clientes(:one)
  end

  test "visiting the index" do
    visit status_clientes_url
    assert_selector "h1", text: "Status Clientes"
  end

  test "creating a Status cliente" do
    visit status_clientes_url
    click_on "New Status Cliente"

    fill_in "Nome", with: @status_cliente.nome
    click_on "Create Status cliente"

    assert_text "Status cliente was successfully created"
    click_on "Back"
  end

  test "updating a Status cliente" do
    visit status_clientes_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @status_cliente.nome
    click_on "Update Status cliente"

    assert_text "Status cliente was successfully updated"
    click_on "Back"
  end

  test "destroying a Status cliente" do
    visit status_clientes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status cliente was successfully destroyed"
  end
end
