require 'test_helper'

class StatusProdutosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_produto = status_produtos(:one)
  end

  test "should get index" do
    get status_produtos_url
    assert_response :success
  end

  test "should get new" do
    get new_status_produto_url
    assert_response :success
  end

  test "should create status_produto" do
    assert_difference('StatusProduto.count') do
      post status_produtos_url, params: { status_produto: { nome: @status_produto.nome } }
    end

    assert_redirected_to status_produto_url(StatusProduto.last)
  end

  test "should show status_produto" do
    get status_produto_url(@status_produto)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_produto_url(@status_produto)
    assert_response :success
  end

  test "should update status_produto" do
    patch status_produto_url(@status_produto), params: { status_produto: { nome: @status_produto.nome } }
    assert_redirected_to status_produto_url(@status_produto)
  end

  test "should destroy status_produto" do
    assert_difference('StatusProduto.count', -1) do
      delete status_produto_url(@status_produto)
    end

    assert_redirected_to status_produtos_url
  end
end
