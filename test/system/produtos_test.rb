require "application_system_test_case"

class ProdutosTest < ApplicationSystemTestCase
  setup do
    @produto = produtos(:one)
  end

  test "visiting the index" do
    visit produtos_url
    assert_selector "h1", text: "Produtos"
  end

  test "creating a Produto" do
    visit produtos_url
    click_on "New Produto"

    fill_in "Description", with: @produto.description
    fill_in "Margem pos", with: @produto.margem_pos
    fill_in "Margem site", with: @produto.margem_site
    fill_in "Margem tef", with: @produto.margem_tef
    fill_in "Margem telemovel", with: @produto.margem_telemovel
    fill_in "Mensagem cupom venda", with: @produto.mensagem_cupom_venda
    fill_in "Partner", with: @produto.partner_id
    fill_in "Status produto", with: @produto.status_produto_id
    fill_in "Valor compra pos", with: @produto.valor_compra_pos
    fill_in "Valor compra site", with: @produto.valor_compra_site
    fill_in "Valor compra tef", with: @produto.valor_compra_tef
    fill_in "Valor compra telemovel", with: @produto.valor_compra_telemovel
    fill_in "Valor minimo venda pos", with: @produto.valor_minimo_venda_pos
    fill_in "Valor minimo venda site", with: @produto.valor_minimo_venda_site
    fill_in "Valor minimo venda tef", with: @produto.valor_minimo_venda_tef
    fill_in "Valor minimo venda telemovel", with: @produto.valor_minimo_venda_telemovel
    click_on "Create Produto"

    assert_text "Produto was successfully created"
    click_on "Back"
  end

  test "updating a Produto" do
    visit produtos_url
    click_on "Edit", match: :first

    fill_in "Description", with: @produto.description
    fill_in "Margem pos", with: @produto.margem_pos
    fill_in "Margem site", with: @produto.margem_site
    fill_in "Margem tef", with: @produto.margem_tef
    fill_in "Margem telemovel", with: @produto.margem_telemovel
    fill_in "Mensagem cupom venda", with: @produto.mensagem_cupom_venda
    fill_in "Partner", with: @produto.partner_id
    fill_in "Status produto", with: @produto.status_produto_id
    fill_in "Valor compra pos", with: @produto.valor_compra_pos
    fill_in "Valor compra site", with: @produto.valor_compra_site
    fill_in "Valor compra tef", with: @produto.valor_compra_tef
    fill_in "Valor compra telemovel", with: @produto.valor_compra_telemovel
    fill_in "Valor minimo venda pos", with: @produto.valor_minimo_venda_pos
    fill_in "Valor minimo venda site", with: @produto.valor_minimo_venda_site
    fill_in "Valor minimo venda tef", with: @produto.valor_minimo_venda_tef
    fill_in "Valor minimo venda telemovel", with: @produto.valor_minimo_venda_telemovel
    click_on "Update Produto"

    assert_text "Produto was successfully updated"
    click_on "Back"
  end

  test "destroying a Produto" do
    visit produtos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Produto was successfully destroyed"
  end
end
