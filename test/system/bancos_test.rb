require "application_system_test_case"

class BancosTest < ApplicationSystemTestCase
  setup do
    @banco = bancos(:one)
  end

  test "visiting the index" do
    visit bancos_url
    assert_selector "h1", text: "Bancos"
  end

  test "creating a Banco" do
    visit bancos_url
    click_on "New Banco"

    fill_in "Email", with: @banco.email
    fill_in "Fax escritorio", with: @banco.fax_escritorio
    fill_in "Fax sede", with: @banco.fax_sede
    fill_in "Logomarca", with: @banco.logomarca
    fill_in "Morada escritorio", with: @banco.morada_escritorio
    fill_in "Morada sede", with: @banco.morada_sede
    fill_in "Nome", with: @banco.nome
    fill_in "Sigla", with: @banco.sigla
    fill_in "Telefone escritorio", with: @banco.telefone_escritorio
    fill_in "Telefone sede", with: @banco.telefone_sede
    fill_in "Website", with: @banco.website
    click_on "Create Banco"

    assert_text "Banco foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Banco" do
    visit bancos_url
    click_on "Edit", match: :first

    fill_in "Email", with: @banco.email
    fill_in "Fax escritorio", with: @banco.fax_escritorio
    fill_in "Fax sede", with: @banco.fax_sede
    fill_in "Logomarca", with: @banco.logomarca
    fill_in "Morada escritorio", with: @banco.morada_escritorio
    fill_in "Morada sede", with: @banco.morada_sede
    fill_in "Nome", with: @banco.nome
    fill_in "Sigla", with: @banco.sigla
    fill_in "Telefone escritorio", with: @banco.telefone_escritorio
    fill_in "Telefone sede", with: @banco.telefone_sede
    fill_in "Website", with: @banco.website
    click_on "Update Banco"

    assert_text "Banco was successfully updated"
    click_on "Back"
  end

  test "destroying a Banco" do
    visit bancos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Banco foi apagado com sucesso"
  end
end
