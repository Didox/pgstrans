require "application_system_test_case"

class StatusAlegacaoPagamentosTest < ApplicationSystemTestCase
  setup do
    @status_alegacao_pagamento = status_alegacao_pagamentos(:one)
  end

  test "visiting the index" do
    visit status_alegacao_pagamentos_url
    assert_selector "h1", text: "Status Alegacao Pagamentos"
  end

  test "creating a Status alegacao pagamento" do
    visit status_alegacao_pagamentos_url
    click_on "New Status Alegacao Pagamento"

    fill_in "Nome", with: @status_alegacao_pagamento.nome
    click_on "Create Status alegacao pagamento"

    assert_text "Status alegacao pagamento was successfully created"
    click_on "Back"
  end

  test "updating a Status alegacao pagamento" do
    visit status_alegacao_pagamentos_url
    click_on "Edit", match: :first

    fill_in "Nome", with: @status_alegacao_pagamento.nome
    click_on "Update Status alegacao pagamento"

    assert_text "Status alegacao pagamento was successfully updated"
    click_on "Back"
  end

  test "destroying a Status alegacao pagamento" do
    visit status_alegacao_pagamentos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status alegacao pagamento was successfully destroyed"
  end
end
