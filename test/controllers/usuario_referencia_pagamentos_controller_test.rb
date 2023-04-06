require 'test_helper'

class UsuarioReferenciaPagamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @usuario_referencia_pagamento = usuario_referencia_pagamentos(:one)
  end

  test "should get index" do
    get usuario_referencia_pagamentos_url
    assert_response :success
  end

  test "should get new" do
    get new_usuario_referencia_pagamento_url
    assert_response :success
  end

  test "should create usuario_referencia_pagamento" do
    assert_difference('UsuarioReferenciaPagamento.count') do
      post usuario_referencia_pagamentos_url, params: { usuario_referencia_pagamento: { acao: @usuario_referencia_pagamento.acao, nro_pagamento_referencia: @usuario_referencia_pagamento.nro_pagamento_referencia, usuario_id: @usuario_referencia_pagamento.usuario_id } }
    end

    assert_redirected_to usuario_referencia_pagamento_url(UsuarioReferenciaPagamento.last)
  end

  test "should show usuario_referencia_pagamento" do
    get usuario_referencia_pagamento_url(@usuario_referencia_pagamento)
    assert_response :success
  end

  test "should get edit" do
    get edit_usuario_referencia_pagamento_url(@usuario_referencia_pagamento)
    assert_response :success
  end

  test "should update usuario_referencia_pagamento" do
    patch usuario_referencia_pagamento_url(@usuario_referencia_pagamento), params: { usuario_referencia_pagamento: { acao: @usuario_referencia_pagamento.acao, nro_pagamento_referencia: @usuario_referencia_pagamento.nro_pagamento_referencia, usuario_id: @usuario_referencia_pagamento.usuario_id } }
    assert_redirected_to usuario_referencia_pagamento_url(@usuario_referencia_pagamento)
  end

  test "should destroy usuario_referencia_pagamento" do
    assert_difference('UsuarioReferenciaPagamento.count', -1) do
      delete usuario_referencia_pagamento_url(@usuario_referencia_pagamento)
    end

    assert_redirected_to usuario_referencia_pagamentos_url
  end
end
