require "application_system_test_case"

class MovimentacaoContaTest < ApplicationSystemTestCase
  setup do
    @movimentacao_contum = movimentacao_conta(:one)
  end

  test "visiting the index" do
    visit movimentacao_conta_url
    assert_selector "h1", text: "Movimentacao Conta"
  end

  test "creating a Movimentacao contum" do
    visit movimentacao_conta_url
    click_on "New Movimentacao Contum"

    fill_in "Nome", with: @movimentacao_contum.nome
    click_on "Create Movimentacao contum"

    assert_text "Movimentacao contum was successfully created"
    click_on "Back"
  end

  test "updating a Movimentacao contum" do
    visit movimentacao_conta_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @movimentacao_contum.nome
    click_on "Update Movimentacao contum"

    assert_text "Movimentacao contum was successfully updated"
    click_on "Back"
  end

  test "destroying a Movimentacao contum" do
    visit movimentacao_conta_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Movimentacao contum was successfully destroyed"
  end
end
