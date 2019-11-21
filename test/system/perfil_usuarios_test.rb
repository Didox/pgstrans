require "application_system_test_case"

class PerfilUsuariosTest < ApplicationSystemTestCase
  setup do
    @perfil_usuario = perfil_usuarios(:one)
  end

  test "visiting the index" do
    visit perfil_usuarios_url
    assert_selector "h1", text: "Perfil Usuarios"
  end

  test "creating a Perfil usuario" do
    visit perfil_usuarios_url
    click_on "New Perfil Usuario"

    check "Admin" if @perfil_usuario.admin
    fill_in "Nome", with: @perfil_usuario.nome
    click_on "Create Perfil usuario"

    assert_text "Perfil usuario foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Perfil usuario" do
    visit perfil_usuarios_url
    click_on "Edit", match: :first

    check "Admin" if @perfil_usuario.admin
    fill_in "Nome", with: @perfil_usuario.nome
    click_on "Update Perfil usuario"

    assert_text "Perfil usuario foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Perfil usuario" do
    visit perfil_usuarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Perfil usuario foi apagado com sucesso"
  end
end
