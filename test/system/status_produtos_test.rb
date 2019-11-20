require "application_system_test_case"

class StatusProdutosTest < ApplicationSystemTestCase
  setup do
    @status_produto = status_produtos(:one)
  end

  test "visiting the index" do
    visit status_produtos_url
    assert_selector "h1", text: "Status Produtos"
  end

  test "creating a Status produto" do
    visit status_produtos_url
    click_on "New Status Produto"

    fill_in "Nome", with: @status_produto.nome
    click_on "Create Status produto"

    assert_text "Status produto was successfully created"
    click_on "Back"
  end

  test "updating a Status produto" do
    visit status_produtos_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @status_produto.nome
    click_on "Update Status produto"

    assert_text "Status produto was successfully updated"
    click_on "Back"
  end

  test "destroying a Status produto" do
    visit status_produtos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status produto was successfully destroyed"
  end
end
