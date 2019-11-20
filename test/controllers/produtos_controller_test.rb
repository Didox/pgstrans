require 'test_helper'

class ProdutosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @produto = produtos(:one)
  end

  test "should get index" do
    get produtos_url
    assert_response :success
  end

  test "should get new" do
    get new_produto_url
    assert_response :success
  end

  test "should create produto" do
    assert_difference('Produto.count') do
      post produtos_url, params: { produto: { description: @produto.description, margem_pos: @produto.margem_pos, margem_site: @produto.margem_site, margem_tef: @produto.margem_tef, margem_telemovel: @produto.margem_telemovel, mensagem_cupom_venda: @produto.mensagem_cupom_venda, partner_id: @produto.partner_id, status_produto_id: @produto.status_produto_id, valor_compra_pos: @produto.valor_compra_pos, valor_compra_site: @produto.valor_compra_site, valor_compra_tef: @produto.valor_compra_tef, valor_compra_telemovel: @produto.valor_compra_telemovel, valor_minimo_venda_pos: @produto.valor_minimo_venda_pos, valor_minimo_venda_site: @produto.valor_minimo_venda_site, valor_minimo_venda_tef: @produto.valor_minimo_venda_tef, valor_minimo_venda_telemovel: @produto.valor_minimo_venda_telemovel } }
    end

    assert_redirected_to produto_url(Produto.last)
  end

  test "should show produto" do
    get produto_url(@produto)
    assert_response :success
  end

  test "should get edit" do
    get edit_produto_url(@produto)
    assert_response :success
  end

  test "should update produto" do
    patch produto_url(@produto), params: { produto: { description: @produto.description, margem_pos: @produto.margem_pos, margem_site: @produto.margem_site, margem_tef: @produto.margem_tef, margem_telemovel: @produto.margem_telemovel, mensagem_cupom_venda: @produto.mensagem_cupom_venda, partner_id: @produto.partner_id, status_produto_id: @produto.status_produto_id, valor_compra_pos: @produto.valor_compra_pos, valor_compra_site: @produto.valor_compra_site, valor_compra_tef: @produto.valor_compra_tef, valor_compra_telemovel: @produto.valor_compra_telemovel, valor_minimo_venda_pos: @produto.valor_minimo_venda_pos, valor_minimo_venda_site: @produto.valor_minimo_venda_site, valor_minimo_venda_tef: @produto.valor_minimo_venda_tef, valor_minimo_venda_telemovel: @produto.valor_minimo_venda_telemovel } }
    assert_redirected_to produto_url(@produto)
  end

  test "should destroy produto" do
    assert_difference('Produto.count', -1) do
      delete produto_url(@produto)
    end

    assert_redirected_to produtos_url
  end
end
