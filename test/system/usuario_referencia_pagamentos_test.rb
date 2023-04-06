require "application_system_test_case"

class UsuarioReferenciaPagamentosTest < ApplicationSystemTestCase
  setup do
    @usuario_referencia_pagamento = usuario_referencia_pagamentos(:one)
  end

  test "visiting the index" do
    visit usuario_referencia_pagamentos_url
    assert_selector "h1", text: "Usuario Referencia Pagamentos"
  end

  test "creating a Usuario referencia pagamento" do
    visit usuario_referencia_pagamentos_url
    click_on "New Usuario Referencia Pagamento"

    fill_in "Acao", with: @usuario_referencia_pagamento.acao
    fill_in "Nro pagamento referencia", with: @usuario_referencia_pagamento.nro_pagamento_referencia
    fill_in "Usuario", with: @usuario_referencia_pagamento.usuario_id
    click_on "Create Usuario referencia pagamento"

    assert_text "Usuario referencia pagamento was successfully created"
    click_on "Back"
  end

  test "updating a Usuario referencia pagamento" do
    visit usuario_referencia_pagamentos_url
    click_on "Edit", match: :first

    fill_in "Acao", with: @usuario_referencia_pagamento.acao
    fill_in "Nro pagamento referencia", with: @usuario_referencia_pagamento.nro_pagamento_referencia
    fill_in "Usuario", with: @usuario_referencia_pagamento.usuario_id
    click_on "Update Usuario referencia pagamento"

    assert_text "Usuario referencia pagamento was successfully updated"
    click_on "Back"
  end

  test "destroying a Usuario referencia pagamento" do
    visit usuario_referencia_pagamentos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Usuario referencia pagamento was successfully destroyed"
  end
end
