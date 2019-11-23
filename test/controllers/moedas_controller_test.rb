require 'test_helper'

class MoedasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moeda = moedas(:one)
  end

  test "should get index" do
    get moedas_url
    assert_response :success
  end

  test "should get new" do
    get new_moeda_url
    assert_response :success
  end

  test "should create moeda" do
    assert_difference('Moeda.count') do
      post moedas_url, params: { moeda: { codigo_iso: @moeda.codigo_iso, country_id: @moeda.country_id, nome: @moeda.nome, simbolo: @moeda.simbolo } }
    end

    assert_redirected_to moeda_url(Moeda.last)
  end

  test "should show moeda" do
    get moeda_url(@moeda)
    assert_response :success
  end

  test "should get edit" do
    get edit_moeda_url(@moeda)
    assert_response :success
  end

  test "should update moeda" do
    patch moeda_url(@moeda), params: { moeda: { codigo_iso: @moeda.codigo_iso, country_id: @moeda.country_id, nome: @moeda.nome, simbolo: @moeda.simbolo } }
    assert_redirected_to moeda_url(@moeda)
  end

  test "should destroy moeda" do
    assert_difference('Moeda.count', -1) do
      delete moeda_url(@moeda)
    end

    assert_redirected_to moedas_url
  end
end
