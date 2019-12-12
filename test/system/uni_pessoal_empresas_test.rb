require "application_system_test_case"

class UniPessoalEmpresasTest < ApplicationSystemTestCase
  setup do
    @uni_pessoal_empresa = uni_pessoal_empresas(:one)
  end

  test "visiting the index" do
    visit uni_pessoal_empresas_url
    assert_selector "h1", text: "Uni Pessoal Empresas"
  end

  test "creating a Uni pessoal empresa" do
    visit uni_pessoal_empresas_url
    click_on "New Uni Pessoal Empresa"

    fill_in "Nome", with: @uni_pessoal_empresa.nome
    click_on "Create Uni pessoal empresa"

    assert_text "Uni pessoal empresa foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Uni pessoal empresa" do
    visit uni_pessoal_empresas_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @uni_pessoal_empresa.nome
    click_on "Update Uni pessoal empresa"

    assert_text "Uni pessoal empresa was successfully updated"
    click_on "Back"
  end

  test "destroying a Uni pessoal empresa" do
    visit uni_pessoal_empresas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Uni pessoal empresa foi apagado com sucesso"
  end
end
