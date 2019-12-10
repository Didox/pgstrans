require "application_system_test_case"

class VendasTest < ApplicationSystemTestCase
  setup do
    @venda = vendas(:one)
  end

  test "visiting the index" do
    visit vendas_url
    assert_selector "h1", text: "Vendas"
  end

  test "creating a Venda" do
    visit vendas_url
    click_on "New Venda"

    fill_in "Agent", with: @venda.agent_id
    fill_in "Client msisdn", with: @venda.client_msisdn
    fill_in "Product", with: @venda.product_id
    fill_in "Request send", with: @venda.request_send
    fill_in "Response get", with: @venda.response_get
    fill_in "Seller", with: @venda.seller_id
    fill_in "Store", with: @venda.store_id
    fill_in "Terminal", with: @venda.terminal_id
    fill_in "Value", with: @venda.value
    click_on "Create Venda"

    assert_text "Venda was successfully created"
    click_on "Back"
  end

  test "updating a Venda" do
    visit vendas_url
    click_on "Edit", match: :first

    fill_in "Agent", with: @venda.agent_id
    fill_in "Client msisdn", with: @venda.client_msisdn
    fill_in "Product", with: @venda.product_id
    fill_in "Request send", with: @venda.request_send
    fill_in "Response get", with: @venda.response_get
    fill_in "Seller", with: @venda.seller_id
    fill_in "Store", with: @venda.store_id
    fill_in "Terminal", with: @venda.terminal_id
    fill_in "Value", with: @venda.value
    click_on "Update Venda"

    assert_text "Venda was successfully updated"
    click_on "Back"
  end

  test "destroying a Venda" do
    visit vendas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Venda was successfully destroyed"
  end
end
