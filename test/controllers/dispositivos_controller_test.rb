require 'test_helper'

class DispositivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dispositivo = dispositivos(:one)
  end

  test "should get index" do
    get dispositivos_url
    assert_response :success
  end

  test "should get new" do
    get new_dispositivo_url
    assert_response :success
  end

  test "should create dispositivo" do
    assert_difference('Dispositivo.count') do
      post dispositivos_url, params: { dispositivo: { imei: @dispositivo.imei, macaddr: @dispositivo.macaddr, marca: @dispositivo.marca, modelo: @dispositivo.modelo, nome: @dispositivo.nome, numero_serie: @dispositivo.numero_serie } }
    end

    assert_redirected_to dispositivo_url(Dispositivo.last)
  end

  test "should show dispositivo" do
    get dispositivo_url(@dispositivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_dispositivo_url(@dispositivo)
    assert_response :success
  end

  test "should update dispositivo" do
    patch dispositivo_url(@dispositivo), params: { dispositivo: { imei: @dispositivo.imei, macaddr: @dispositivo.macaddr, marca: @dispositivo.marca, modelo: @dispositivo.modelo, nome: @dispositivo.nome, numero_serie: @dispositivo.numero_serie } }
    assert_redirected_to dispositivo_url(@dispositivo)
  end

  test "should destroy dispositivo" do
    assert_difference('Dispositivo.count', -1) do
      delete dispositivo_url(@dispositivo)
    end

    assert_redirected_to dispositivos_url
  end
end
