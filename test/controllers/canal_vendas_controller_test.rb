require 'test_helper'

class CanalVendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @canal_venda = canal_vendas(:one)
  end

  test "should get index" do
    get canal_vendas_url
    assert_response :success
  end

  test "should get new" do
    get new_canal_venda_url
    assert_response :success
  end

  test "should create canal_venda" do
    assert_difference('CanalVenda.count') do
      post canal_vendas_url, params: { canal_venda: { carragamento_minimo: @canal_venda.carragamento_minimo, dispositivo_id: @canal_venda.dispositivo_id, nome: @canal_venda.nome } }
    end

    assert_redirected_to canal_venda_url(CanalVenda.last)
  end

  test "should show canal_venda" do
    get canal_venda_url(@canal_venda)
    assert_response :success
  end

  test "should get edit" do
    get edit_canal_venda_url(@canal_venda)
    assert_response :success
  end

  test "should update canal_venda" do
    patch canal_venda_url(@canal_venda), params: { canal_venda: { carragamento_minimo: @canal_venda.carragamento_minimo, dispositivo_id: @canal_venda.dispositivo_id, nome: @canal_venda.nome } }
    assert_redirected_to canal_venda_url(@canal_venda)
  end

  test "should destroy canal_venda" do
    assert_difference('CanalVenda.count', -1) do
      delete canal_venda_url(@canal_venda)
    end

    assert_redirected_to canal_vendas_url
  end
end
