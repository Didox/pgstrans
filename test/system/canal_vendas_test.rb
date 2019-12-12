require "application_system_test_case"

class CanalVendasTest < ApplicationSystemTestCase
  setup do
    @canal_venda = canal_vendas(:one)
  end

  test "visiting the index" do
    visit canal_vendas_url
    assert_selector "h1", text: "Canal Vendas"
  end

  test "creating a Canal venda" do
    visit canal_vendas_url
    click_on "New Canal Venda"

    fill_in "Carragamento minimo", with: @canal_venda.carragamento_minimo
    fill_in "Dispositivo", with: @canal_venda.dispositivo_id
    fill_in "Nome", with: @canal_venda.nome
    click_on "Create Canal venda"

    assert_text "Canal venda foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Canal venda" do
    visit canal_vendas_url
    click_on "Edit", match: :first

    fill_in "Carragamento minimo", with: @canal_venda.carragamento_minimo
    fill_in "Dispositivo", with: @canal_venda.dispositivo_id
    fill_in "Nome", with: @canal_venda.nome
    click_on "Update Canal venda"

    assert_text "Canal venda was successfully updated"
    click_on "Back"
  end

  test "destroying a Canal venda" do
    visit canal_vendas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Canal venda foi apagado com sucesso"
  end
end
