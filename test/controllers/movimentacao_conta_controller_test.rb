require 'test_helper'

class MovimentacaoContaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movimentacao_contum = movimentacao_conta(:one)
  end

  test "should get index" do
    get movimentacao_conta_url
    assert_response :success
  end

  test "should get new" do
    get new_movimentacao_contum_url
    assert_response :success
  end

  test "should create movimentacao_contum" do
    assert_difference('MovimentacaoContum.count') do
      post movimentacao_conta_url, params: { movimentacao_contum: { nome: @movimentacao_contum.nome } }
    end

    assert_redirected_to movimentacao_contum_url(MovimentacaoContum.last)
  end

  test "should show movimentacao_contum" do
    get movimentacao_contum_url(@movimentacao_contum)
    assert_response :success
  end

  test "should get edit" do
    get edit_movimentacao_contum_url(@movimentacao_contum)
    assert_response :success
  end

  test "should update movimentacao_contum" do
    patch movimentacao_contum_url(@movimentacao_contum), params: { movimentacao_contum: { nome: @movimentacao_contum.nome } }
    assert_redirected_to movimentacao_contum_url(@movimentacao_contum)
  end

  test "should destroy movimentacao_contum" do
    assert_difference('MovimentacaoContum.count', -1) do
      delete movimentacao_contum_url(@movimentacao_contum)
    end

    assert_redirected_to movimentacao_conta_url
  end
end
