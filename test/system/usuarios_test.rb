require "application_system_test_case"

class UsuariosTest < ApplicationSystemTestCase
  setup do
    @usuario = usuarios(:one)
  end

  test "visiting the index" do
    visit usuarios_url
    assert_selector "h1", text: "Usuarios"
  end

  test "creating a Usuario" do
    visit usuarios_url
    click_on "New Usuario"

    fill_in "Email", with: @usuario.email
    fill_in "Nome", with: @usuario.nome
    fill_in "Senha", with: @usuario.senha
    click_on "Create Usuario"

    assert_text "Usuario foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Usuario" do
    visit usuarios_url
    click_on "Edit", match: :first

    fill_in "Email", with: @usuario.email
    fill_in "Nome", with: @usuario.nome
    fill_in "Senha", with: @usuario.senha
    click_on "Update Usuario"

    assert_text "Usuario foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Usuario" do
    visit usuarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Usuario foi apagado com sucesso"
  end
end
