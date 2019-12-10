require 'test_helper'

class VendasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @venda = vendas(:one)
  end

  test "should get index" do
    get vendas_url
    assert_response :success
  end

  test "should get new" do
    get new_venda_url
    assert_response :success
  end

  test "should create venda" do
    assert_difference('Venda.count') do
      post vendas_url, params: { venda: { agent_id: @venda.agent_id, client_msisdn: @venda.client_msisdn, product_id: @venda.product_id, request_send: @venda.request_send, response_get: @venda.response_get, seller_id: @venda.seller_id, store_id: @venda.store_id, terminal_id: @venda.terminal_id, value: @venda.value } }
    end

    assert_redirected_to venda_url(Venda.last)
  end

  test "should show venda" do
    get venda_url(@venda)
    assert_response :success
  end

  test "should get edit" do
    get edit_venda_url(@venda)
    assert_response :success
  end

  test "should update venda" do
    patch venda_url(@venda), params: { venda: { agent_id: @venda.agent_id, client_msisdn: @venda.client_msisdn, product_id: @venda.product_id, request_send: @venda.request_send, response_get: @venda.response_get, seller_id: @venda.seller_id, store_id: @venda.store_id, terminal_id: @venda.terminal_id, value: @venda.value } }
    assert_redirected_to venda_url(@venda)
  end

  test "should destroy venda" do
    assert_difference('Venda.count', -1) do
      delete venda_url(@venda)
    end

    assert_redirected_to vendas_url
  end
end
