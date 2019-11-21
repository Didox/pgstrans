require 'test_helper'

class LancamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lancamento = lancamentos(:one)
  end

  test "should get index" do
    get lancamentos_url
    assert_response :success
  end

  test "should get new" do
    get new_lancamento_url
    assert_response :success
  end

  test "should create lancamento" do
    assert_difference('Lancamento.count') do
      post lancamentos_url, params: { lancamento: { nome: @lancamento.nome } }
    end

    assert_redirected_to lancamento_url(Lancamento.last)
  end

  test "should show lancamento" do
    get lancamento_url(@lancamento)
    assert_response :success
  end

  test "should get edit" do
    get edit_lancamento_url(@lancamento)
    assert_response :success
  end

  test "should update lancamento" do
    patch lancamento_url(@lancamento), params: { lancamento: { nome: @lancamento.nome } }
    assert_redirected_to lancamento_url(@lancamento)
  end

  test "should destroy lancamento" do
    assert_difference('Lancamento.count', -1) do
      delete lancamento_url(@lancamento)
    end

    assert_redirected_to lancamentos_url
  end
end
