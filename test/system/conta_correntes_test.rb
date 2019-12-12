require "application_system_test_case"

class ContaCorrentesTest < ApplicationSystemTestCase
  setup do
    @conta_corrente = conta_correntes(:one)
  end

  test "visiting the index" do
    visit conta_correntes_url
    assert_selector "h1", text: "Conta Correntes"
  end

  test "creating a Conta corrente" do
    visit conta_correntes_url
    click_on "New Conta Corrente"

    fill_in "Banco", with: @conta_corrente.banco_id
    fill_in "Data alegacao pagamento", with: @conta_corrente.data_alegacao_pagamento
    fill_in "Data ultima atualizacao saldo", with: @conta_corrente.data_ultima_atualizacao_saldo
    fill_in "Iban", with: @conta_corrente.iban
    fill_in "Lancamento", with: @conta_corrente.lancamento_id
    fill_in "Observacao", with: @conta_corrente.observacao
    fill_in "Saldo anterior", with: @conta_corrente.saldo_anterior
    fill_in "Saldo atual", with: @conta_corrente.saldo_atual
    fill_in "Usuario", with: @conta_corrente.usuario_id
    fill_in "Valor", with: @conta_corrente.valor
    click_on "Create Conta corrente"

    assert_text "Conta corrente foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Conta corrente" do
    visit conta_correntes_url
    click_on "Edit", match: :first

    fill_in "Banco", with: @conta_corrente.banco_id
    fill_in "Data alegacao pagamento", with: @conta_corrente.data_alegacao_pagamento
    fill_in "Data ultima atualizacao saldo", with: @conta_corrente.data_ultima_atualizacao_saldo
    fill_in "Iban", with: @conta_corrente.iban
    fill_in "Lancamento", with: @conta_corrente.lancamento_id
    fill_in "Observacao", with: @conta_corrente.observacao
    fill_in "Saldo anterior", with: @conta_corrente.saldo_anterior
    fill_in "Saldo atual", with: @conta_corrente.saldo_atual
    fill_in "Usuario", with: @conta_corrente.usuario_id
    fill_in "Valor", with: @conta_corrente.valor
    click_on "Update Conta corrente"

    assert_text "Conta corrente foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Conta corrente" do
    visit conta_correntes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Conta corrente foi apagado com sucesso"
  end
end
