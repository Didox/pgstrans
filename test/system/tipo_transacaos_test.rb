require "application_system_test_case"

class TipoTransacaosTest < ApplicationSystemTestCase
  setup do
    @tipo_transacao = tipo_transacaos(:one)
  end

  test "visiting the index" do
    visit tipo_transacaos_url
    assert_selector "h1", text: "Tipo Transacaos"
  end

  test "creating a Tipo transacao" do
    visit tipo_transacaos_url
    click_on "New Tipo Transacao"

    fill_in "Nome", with: @tipo_transacao.nome
    click_on "Create Tipo transacao"

    assert_text "Tipo transacao foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Tipo transacao" do
    visit tipo_transacaos_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @tipo_transacao.nome
    click_on "Update Tipo transacao"

    assert_text "Tipo transacao foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Tipo transacao" do
    visit tipo_transacaos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo transacao foi apagado com sucesso"
  end
end
