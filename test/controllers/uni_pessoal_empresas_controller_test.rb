require 'test_helper'

class UniPessoalEmpresasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @uni_pessoal_empresa = uni_pessoal_empresas(:one)
  end

  test "should get index" do
    get uni_pessoal_empresas_url
    assert_response :success
  end

  test "should get new" do
    get new_uni_pessoal_empresa_url
    assert_response :success
  end

  test "should create uni_pessoal_empresa" do
    assert_difference('UniPessoalEmpresa.count') do
      post uni_pessoal_empresas_url, params: { uni_pessoal_empresa: { nome: @uni_pessoal_empresa.nome } }
    end

    assert_redirected_to uni_pessoal_empresa_url(UniPessoalEmpresa.last)
  end

  test "should show uni_pessoal_empresa" do
    get uni_pessoal_empresa_url(@uni_pessoal_empresa)
    assert_response :success
  end

  test "should get edit" do
    get edit_uni_pessoal_empresa_url(@uni_pessoal_empresa)
    assert_response :success
  end

  test "should update uni_pessoal_empresa" do
    patch uni_pessoal_empresa_url(@uni_pessoal_empresa), params: { uni_pessoal_empresa: { nome: @uni_pessoal_empresa.nome } }
    assert_redirected_to uni_pessoal_empresa_url(@uni_pessoal_empresa)
  end

  test "should destroy uni_pessoal_empresa" do
    assert_difference('UniPessoalEmpresa.count', -1) do
      delete uni_pessoal_empresa_url(@uni_pessoal_empresa)
    end

    assert_redirected_to uni_pessoal_empresas_url
  end
end
