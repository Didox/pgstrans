require 'test_helper'

class TipoTransacaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_transacao = tipo_transacaos(:one)
  end

  test "should get index" do
    get tipo_transacaos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_transacao_url
    assert_response :success
  end

  test "should create tipo_transacao" do
    assert_difference('TipoTransacao.count') do
      post tipo_transacaos_url, params: { tipo_transacao: { nome: @tipo_transacao.nome } }
    end

    assert_redirected_to tipo_transacao_url(TipoTransacao.last)
  end

  test "should show tipo_transacao" do
    get tipo_transacao_url(@tipo_transacao)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_transacao_url(@tipo_transacao)
    assert_response :success
  end

  test "should update tipo_transacao" do
    patch tipo_transacao_url(@tipo_transacao), params: { tipo_transacao: { nome: @tipo_transacao.nome } }
    assert_redirected_to tipo_transacao_url(@tipo_transacao)
  end

  test "should destroy tipo_transacao" do
    assert_difference('TipoTransacao.count', -1) do
      delete tipo_transacao_url(@tipo_transacao)
    end

    assert_redirected_to tipo_transacaos_url
  end
end
