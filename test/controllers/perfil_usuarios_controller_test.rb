require 'test_helper'

class PerfilUsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perfil_usuario = perfil_usuarios(:one)
  end

  test "should get index" do
    get perfil_usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_perfil_usuario_url
    assert_response :success
  end

  test "should create perfil_usuario" do
    assert_difference('PerfilUsuario.count') do
      post perfil_usuarios_url, params: { perfil_usuario: { admin: @perfil_usuario.admin, nome: @perfil_usuario.nome } }
    end

    assert_redirected_to perfil_usuario_url(PerfilUsuario.last)
  end

  test "should show perfil_usuario" do
    get perfil_usuario_url(@perfil_usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_perfil_usuario_url(@perfil_usuario)
    assert_response :success
  end

  test "should update perfil_usuario" do
    patch perfil_usuario_url(@perfil_usuario), params: { perfil_usuario: { admin: @perfil_usuario.admin, nome: @perfil_usuario.nome } }
    assert_redirected_to perfil_usuario_url(@perfil_usuario)
  end

  test "should destroy perfil_usuario" do
    assert_difference('PerfilUsuario.count', -1) do
      delete perfil_usuario_url(@perfil_usuario)
    end

    assert_redirected_to perfil_usuarios_url
  end
end
