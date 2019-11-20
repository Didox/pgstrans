require "application_system_test_case"

class SubAgentesTest < ApplicationSystemTestCase
  setup do
    @sub_agente = sub_agentes(:one)
  end

  test "visiting the index" do
    visit sub_agentes_url
    assert_selector "h1", text: "Sub Agentes"
  end

  test "creating a Sub agente" do
    visit sub_agentes_url
    click_on "New Sub Agente"

    fill_in "Bairro", with: @sub_agente.bairro
    fill_in "Bi", with: @sub_agente.bi
    fill_in "Email", with: @sub_agente.email
    fill_in "Industry", with: @sub_agente.industry_id
    fill_in "Morada", with: @sub_agente.morada
    fill_in "Nome fantasia", with: @sub_agente.nome_fantasia
    fill_in "Provincia", with: @sub_agente.provincia
    fill_in "Razao social", with: @sub_agente.razao_social
    fill_in "Telefone", with: @sub_agente.telefone
    click_on "Create Sub agente"

    assert_text "Sub agente was successfully created"
    click_on "Back"
  end

  test "updating a Sub agente" do
    visit sub_agentes_url
    click_on "Edit", match: :first

    fill_in "Bairro", with: @sub_agente.bairro
    fill_in "Bi", with: @sub_agente.bi
    fill_in "Email", with: @sub_agente.email
    fill_in "Industry", with: @sub_agente.industry_id
    fill_in "Morada", with: @sub_agente.morada
    fill_in "Nome fantasia", with: @sub_agente.nome_fantasia
    fill_in "Provincia", with: @sub_agente.provincia
    fill_in "Razao social", with: @sub_agente.razao_social
    fill_in "Telefone", with: @sub_agente.telefone
    click_on "Update Sub agente"

    assert_text "Sub agente was successfully updated"
    click_on "Back"
  end

  test "destroying a Sub agente" do
    visit sub_agentes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sub agente was successfully destroyed"
  end
end
