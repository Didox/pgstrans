require 'test_helper'

class StatusAlegacaoPagamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_alegacao_pagamento = status_alegacao_pagamentos(:one)
  end

  test "should get index" do
    get status_alegacao_pagamentos_url
    assert_response :success
  end

  test "should get new" do
    get new_status_alegacao_pagamento_url
    assert_response :success
  end

  test "should create status_alegacao_pagamento" do
    assert_difference('StatusAlegacaoPagamento.count') do
      post status_alegacao_pagamentos_url, params: { status_alegacao_pagamento: { nome: @status_alegacao_pagamento.nome } }
    end

    assert_redirected_to status_alegacao_pagamento_url(StatusAlegacaoPagamento.last)
  end

  test "should show status_alegacao_pagamento" do
    get status_alegacao_pagamento_url(@status_alegacao_pagamento)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_alegacao_pagamento_url(@status_alegacao_pagamento)
    assert_response :success
  end

  test "should update status_alegacao_pagamento" do
    patch status_alegacao_pagamento_url(@status_alegacao_pagamento), params: { status_alegacao_pagamento: { nome: @status_alegacao_pagamento.nome } }
    assert_redirected_to status_alegacao_pagamento_url(@status_alegacao_pagamento)
  end

  test "should destroy status_alegacao_pagamento" do
    assert_difference('StatusAlegacaoPagamento.count', -1) do
      delete status_alegacao_pagamento_url(@status_alegacao_pagamento)
    end

    assert_redirected_to status_alegacao_pagamentos_url
  end
end
