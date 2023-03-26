require 'rails_helper'

RSpec.describe "pagamento_referencia/index", type: :view do
  before(:each) do
    assign(:pagamento_referencia, [
      PagamentoReferencia.create!(
        usuario: "",
        nro_pagamento_referencia: 2,
        id_trn_parceiro: 3,
        valor_pagamento: 4.5,
        terminal_id: "Terminal",
        terminal_location: "Terminal Location",
        terminal_type: "Terminal Type"
      ),
      PagamentoReferencia.create!(
        usuario: "",
        nro_pagamento_referencia: 2,
        id_trn_parceiro: 3,
        valor_pagamento: 4.5,
        terminal_id: "Terminal",
        terminal_location: "Terminal Location",
        terminal_type: "Terminal Type"
      )
    ])
  end

  it "renders a list of pagamento_referencia" do
    render
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.5.to_s, count: 2
    assert_select "tr>td", text: "Terminal".to_s, count: 2
    assert_select "tr>td", text: "Terminal Location".to_s, count: 2
    assert_select "tr>td", text: "Terminal Type".to_s, count: 2
  end
end
