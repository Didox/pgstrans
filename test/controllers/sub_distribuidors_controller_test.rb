require 'test_helper'

class SubDistribuidorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_distribuidor = sub_distribuidors(:one)
  end

  test "should get index" do
    get sub_distribuidors_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_distribuidor_url
    assert_response :success
  end

  test "should create sub_distribuidor" do
    assert_difference('SubDistribuidor.count') do
      post sub_distribuidors_url, params: { sub_distribuidor: { bi: @sub_distribuidor.bi, morada: @sub_distribuidor.morada, municipio: @sub_distribuidor.municipio, nome: @sub_distribuidor.nome, provincia: @sub_distribuidor.provincia, telefone: @sub_distribuidor.telefone } }
    end

    assert_redirected_to sub_distribuidor_url(SubDistribuidor.last)
  end

  test "should show sub_distribuidor" do
    get sub_distribuidor_url(@sub_distribuidor)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_distribuidor_url(@sub_distribuidor)
    assert_response :success
  end

  test "should update sub_distribuidor" do
    patch sub_distribuidor_url(@sub_distribuidor), params: { sub_distribuidor: { bi: @sub_distribuidor.bi, morada: @sub_distribuidor.morada, municipio: @sub_distribuidor.municipio, nome: @sub_distribuidor.nome, provincia: @sub_distribuidor.provincia, telefone: @sub_distribuidor.telefone } }
    assert_redirected_to sub_distribuidor_url(@sub_distribuidor)
  end

  test "should destroy sub_distribuidor" do
    assert_difference('SubDistribuidor.count', -1) do
      delete sub_distribuidor_url(@sub_distribuidor)
    end

    assert_redirected_to sub_distribuidors_url
  end
end
