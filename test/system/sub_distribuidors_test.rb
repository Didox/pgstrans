require "application_system_test_case"

class SubDistribuidorsTest < ApplicationSystemTestCase
  setup do
    @sub_distribuidor = sub_distribuidors(:one)
  end

  test "visiting the index" do
    visit sub_distribuidors_url
    assert_selector "h1", text: "Sub Distribuidors"
  end

  test "creating a Sub distribuidor" do
    visit sub_distribuidors_url
    click_on "New Sub Distribuidor"

    fill_in "Bi", with: @sub_distribuidor.bi
    fill_in "Morada", with: @sub_distribuidor.morada
    fill_in "Municipio", with: @sub_distribuidor.municipio
    fill_in "Nome", with: @sub_distribuidor.nome
    fill_in "Provincia", with: @sub_distribuidor.provincia
    fill_in "Telefone", with: @sub_distribuidor.telefone
    click_on "Create Sub distribuidor"

    assert_text "Sub distribuidor foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Sub distribuidor" do
    visit sub_distribuidors_url
    click_on "Edit", match: :first

    fill_in "Bi", with: @sub_distribuidor.bi
    fill_in "Morada", with: @sub_distribuidor.morada
    fill_in "Municipio", with: @sub_distribuidor.municipio
    fill_in "Nome", with: @sub_distribuidor.nome
    fill_in "Provincia", with: @sub_distribuidor.provincia
    fill_in "Telefone", with: @sub_distribuidor.telefone
    click_on "Update Sub distribuidor"

    assert_text "Sub distribuidor foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Sub distribuidor" do
    visit sub_distribuidors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sub distribuidor foi apagado com sucesso"
  end
end
