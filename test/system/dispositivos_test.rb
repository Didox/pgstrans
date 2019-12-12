require "application_system_test_case"

class DispositivosTest < ApplicationSystemTestCase
  setup do
    @dispositivo = dispositivos(:one)
  end

  test "visiting the index" do
    visit dispositivos_url
    assert_selector "h1", text: "Dispositivos"
  end

  test "creating a Dispositivo" do
    visit dispositivos_url
    click_on "New Dispositivo"

    fill_in "Imei", with: @dispositivo.imei
    fill_in "Macaddr", with: @dispositivo.macaddr
    fill_in "Marca", with: @dispositivo.marca
    fill_in "Modelo", with: @dispositivo.modelo
    fill_in "Nome", with: @dispositivo.nome
    fill_in "Numero serie", with: @dispositivo.numero_serie
    click_on "Create Dispositivo"

    assert_text "Dispositivo foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Dispositivo" do
    visit dispositivos_url
    click_on "Edit", match: :first

    fill_in "Imei", with: @dispositivo.imei
    fill_in "Macaddr", with: @dispositivo.macaddr
    fill_in "Marca", with: @dispositivo.marca
    fill_in "Modelo", with: @dispositivo.modelo
    fill_in "Nome", with: @dispositivo.nome
    fill_in "Numero serie", with: @dispositivo.numero_serie
    click_on "Update Dispositivo"

    assert_text "Dispositivo foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Dispositivo" do
    visit dispositivos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dispositivo foi apagado com sucesso"
  end
end
