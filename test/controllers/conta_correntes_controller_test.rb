require 'test_helper'

class ContaCorrentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @conta_corrente = conta_correntes(:one)
  end

  test "should get index" do
    get conta_correntes_url
    assert_response :success
  end

  test "should get new" do
    get new_conta_corrente_url
    assert_response :success
  end

  test "should create conta_corrente" do
    assert_difference('ContaCorrente.count') do
      post conta_correntes_url, params: { conta_corrente: { banco_id: @conta_corrente.banco_id, data_alegacao_pagamento: @conta_corrente.data_alegacao_pagamento, data_ultima_atualizacao_saldo: @conta_corrente.data_ultima_atualizacao_saldo, iban: @conta_corrente.iban, lancamento_id: @conta_corrente.lancamento_id, observacao: @conta_corrente.observacao, saldo_anterior: @conta_corrente.saldo_anterior, saldo_atual: @conta_corrente.saldo_atual, usuario_id: @conta_corrente.usuario_id, valor: @conta_corrente.valor } }
    end

    assert_redirected_to conta_corrente_url(ContaCorrente.last)
  end

  test "should show conta_corrente" do
    get conta_corrente_url(@conta_corrente)
    assert_response :success
  end

  test "should get edit" do
    get edit_conta_corrente_url(@conta_corrente)
    assert_response :success
  end

  test "should update conta_corrente" do
    patch conta_corrente_url(@conta_corrente), params: { conta_corrente: { banco_id: @conta_corrente.banco_id, data_alegacao_pagamento: @conta_corrente.data_alegacao_pagamento, data_ultima_atualizacao_saldo: @conta_corrente.data_ultima_atualizacao_saldo, iban: @conta_corrente.iban, lancamento_id: @conta_corrente.lancamento_id, observacao: @conta_corrente.observacao, saldo_anterior: @conta_corrente.saldo_anterior, saldo_atual: @conta_corrente.saldo_atual, usuario_id: @conta_corrente.usuario_id, valor: @conta_corrente.valor } }
    assert_redirected_to conta_corrente_url(@conta_corrente)
  end

  test "should destroy conta_corrente" do
    assert_difference('ContaCorrente.count', -1) do
      delete conta_corrente_url(@conta_corrente)
    end

    assert_redirected_to conta_correntes_url
  end
end
