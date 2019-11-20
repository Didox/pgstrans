require 'test_helper'

class SubAgentesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sub_agente = sub_agentes(:one)
  end

  test "should get index" do
    get sub_agentes_url
    assert_response :success
  end

  test "should get new" do
    get new_sub_agente_url
    assert_response :success
  end

  test "should create sub_agente" do
    assert_difference('SubAgente.count') do
      post sub_agentes_url, params: { sub_agente: { bairro: @sub_agente.bairro, bi: @sub_agente.bi, email: @sub_agente.email, industry_id: @sub_agente.industry_id, morada: @sub_agente.morada, nome_fantasia: @sub_agente.nome_fantasia, provincia: @sub_agente.provincia, razao_social: @sub_agente.razao_social, telefone: @sub_agente.telefone } }
    end

    assert_redirected_to sub_agente_url(SubAgente.last)
  end

  test "should show sub_agente" do
    get sub_agente_url(@sub_agente)
    assert_response :success
  end

  test "should get edit" do
    get edit_sub_agente_url(@sub_agente)
    assert_response :success
  end

  test "should update sub_agente" do
    patch sub_agente_url(@sub_agente), params: { sub_agente: { bairro: @sub_agente.bairro, bi: @sub_agente.bi, email: @sub_agente.email, industry_id: @sub_agente.industry_id, morada: @sub_agente.morada, nome_fantasia: @sub_agente.nome_fantasia, provincia: @sub_agente.provincia, razao_social: @sub_agente.razao_social, telefone: @sub_agente.telefone } }
    assert_redirected_to sub_agente_url(@sub_agente)
  end

  test "should destroy sub_agente" do
    assert_difference('SubAgente.count', -1) do
      delete sub_agente_url(@sub_agente)
    end

    assert_redirected_to sub_agentes_url
  end
end
