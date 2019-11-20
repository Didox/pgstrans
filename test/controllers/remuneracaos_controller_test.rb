require 'test_helper'

class RemuneracaosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @remuneracao = remuneracaos(:one)
  end

  test "should get index" do
    get remuneracaos_url
    assert_response :success
  end

  test "should get new" do
    get new_remuneracao_url
    assert_response :success
  end

  test "should create remuneracao" do
    assert_difference('Remuneracao.count') do
      post remuneracaos_url, params: { remuneracao: { nome: @remuneracao.nome, produto_id: @remuneracao.produto_id, usuario_id: @remuneracao.usuario_id, valor_venda_final_pos: @remuneracao.valor_venda_final_pos, valor_venda_final_site: @remuneracao.valor_venda_final_site, valor_venda_final_tef: @remuneracao.valor_venda_final_tef, valor_venda_final_telemovel: @remuneracao.valor_venda_final_telemovel, vigencia_fim: @remuneracao.vigencia_fim, vigencia_inicio: @remuneracao.vigencia_inicio } }
    end

    assert_redirected_to remuneracao_url(Remuneracao.last)
  end

  test "should show remuneracao" do
    get remuneracao_url(@remuneracao)
    assert_response :success
  end

  test "should get edit" do
    get edit_remuneracao_url(@remuneracao)
    assert_response :success
  end

  test "should update remuneracao" do
    patch remuneracao_url(@remuneracao), params: { remuneracao: { nome: @remuneracao.nome, produto_id: @remuneracao.produto_id, usuario_id: @remuneracao.usuario_id, valor_venda_final_pos: @remuneracao.valor_venda_final_pos, valor_venda_final_site: @remuneracao.valor_venda_final_site, valor_venda_final_tef: @remuneracao.valor_venda_final_tef, valor_venda_final_telemovel: @remuneracao.valor_venda_final_telemovel, vigencia_fim: @remuneracao.vigencia_fim, vigencia_inicio: @remuneracao.vigencia_inicio } }
    assert_redirected_to remuneracao_url(@remuneracao)
  end

  test "should destroy remuneracao" do
    assert_difference('Remuneracao.count', -1) do
      delete remuneracao_url(@remuneracao)
    end

    assert_redirected_to remuneracaos_url
  end
end
