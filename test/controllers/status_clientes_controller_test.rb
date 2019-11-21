require 'test_helper'

class StatusClientesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_cliente = status_clientes(:one)
  end

  test "should get index" do
    get status_clientes_url
    assert_response :success
  end

  test "should get new" do
    get new_status_cliente_url
    assert_response :success
  end

  test "should create status_cliente" do
    assert_difference('StatusCliente.count') do
      post status_clientes_url, params: { status_cliente: { nome: @status_cliente.nome } }
    end

    assert_redirected_to status_cliente_url(StatusCliente.last)
  end

  test "should show status_cliente" do
    get status_cliente_url(@status_cliente)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_cliente_url(@status_cliente)
    assert_response :success
  end

  test "should update status_cliente" do
    patch status_cliente_url(@status_cliente), params: { status_cliente: { nome: @status_cliente.nome } }
    assert_redirected_to status_cliente_url(@status_cliente)
  end

  test "should destroy status_cliente" do
    assert_difference('StatusCliente.count', -1) do
      delete status_cliente_url(@status_cliente)
    end

    assert_redirected_to status_clientes_url
  end
end
