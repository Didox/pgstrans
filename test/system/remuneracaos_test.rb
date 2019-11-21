require "application_system_test_case"

class RemuneracaosTest < ApplicationSystemTestCase
  setup do
    @remuneracao = remuneracaos(:one)
  end

  test "visiting the index" do
    visit remuneracaos_url
    assert_selector "h1", text: "Remuneracaos"
  end

  test "creating a Remuneracao" do
    visit remuneracaos_url
    click_on "New Remuneracao"

    fill_in "Nome", with: @remuneracao.nome
    fill_in "Produto", with: @remuneracao.produto_id
    fill_in "Usuario", with: @remuneracao.usuario_id
    fill_in "Valor venda final pos", with: @remuneracao.valor_venda_final_pos
    fill_in "Valor venda final site", with: @remuneracao.valor_venda_final_site
    fill_in "Valor venda final tef", with: @remuneracao.valor_venda_final_tef
    fill_in "Valor venda final telemovel", with: @remuneracao.valor_venda_final_telemovel
    fill_in "Vigencia fim", with: @remuneracao.vigencia_fim
    fill_in "Vigencia inicio", with: @remuneracao.vigencia_inicio
    click_on "Create Remuneracao"

    assert_text "Remuneracao foi criado com sucesso"
    click_on "Back"
  end

  test "updating a Remuneracao" do
    visit remuneracaos_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @remuneracao.nome
    fill_in "Produto", with: @remuneracao.produto_id
    fill_in "Usuario", with: @remuneracao.usuario_id
    fill_in "Valor venda final pos", with: @remuneracao.valor_venda_final_pos
    fill_in "Valor venda final site", with: @remuneracao.valor_venda_final_site
    fill_in "Valor venda final tef", with: @remuneracao.valor_venda_final_tef
    fill_in "Valor venda final telemovel", with: @remuneracao.valor_venda_final_telemovel
    fill_in "Vigencia fim", with: @remuneracao.vigencia_fim
    fill_in "Vigencia inicio", with: @remuneracao.vigencia_inicio
    click_on "Update Remuneracao"

    assert_text "Remuneracao foi atualizado com sucesso"
    click_on "Back"
  end

  test "destroying a Remuneracao" do
    visit remuneracaos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Remuneracao foi apagado com sucesso"
  end
end
