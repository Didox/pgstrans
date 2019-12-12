require 'test_helper'

class StatusParceirosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_parceiro = status_parceiros(:one)
  end

  test "should get index" do
    get status_parceiros_url
    assert_response :success
  end

  test "should get new" do
    get new_status_parceiro_url
    assert_response :success
  end

  test "should create status_parceiro" do
    assert_difference('StatusParceiro.count') do
      post status_parceiros_url, params: { status_parceiro: { nome: @status_parceiro.nome } }
    end

    assert_redirected_to status_parceiro_url(StatusParceiro.last)
  end

  test "should show status_parceiro" do
    get status_parceiro_url(@status_parceiro)
    assert_response :success
  end

  test "should get edit" do
    get edit_status_parceiro_url(@status_parceiro)
    assert_response :success
  end

  test "should update status_parceiro" do
    patch status_parceiro_url(@status_parceiro), params: { status_parceiro: { nome: @status_parceiro.nome } }
    assert_redirected_to status_parceiro_url(@status_parceiro)
  end

  test "should destroy status_parceiro" do
    assert_difference('StatusParceiro.count', -1) do
      delete status_parceiro_url(@status_parceiro)
    end

    assert_redirected_to status_parceiros_url
  end
end
