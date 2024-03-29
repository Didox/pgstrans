require 'rails_helper'

RSpec.describe "pagamento_referencia/edit", type: :view do
  before(:each) do
    @pagamento_referencia = assign(:pagamento_referencia, PagamentoReferencia.create!(
      usuario: "",
      nro_pagamento_referencia: 1,
      id_parceiro: 1,
      valor_pagamento: 1.5,
      terminal_id: "MyString",
      terminal_location: "MyString",
      terminal_type: "MyString"
    ))
  end

  it "renders the edit pagamento_referencia form" do
    render

    assert_select "form[action=?][method=?]", pagamento_referencia_path(@pagamento_referencia), "post" do

      assert_select "input[name=?]", "pagamento_referencia[usuario]"

      assert_select "input[name=?]", "pagamento_referencia[nro_pagamento_referencia]"

      assert_select "input[name=?]", "pagamento_referencia[id_parceiro]"

      assert_select "input[name=?]", "pagamento_referencia[valor_pagamento]"

      assert_select "input[name=?]", "pagamento_referencia[terminal_id]"

      assert_select "input[name=?]", "pagamento_referencia[terminal_location]"

      assert_select "input[name=?]", "pagamento_referencia[terminal_type]"
    end
  end
end
