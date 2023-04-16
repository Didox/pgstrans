require 'rails_helper'

RSpec.describe "pagamento_referencia/show", type: :view do
  before(:each) do
    @pagamento_referencia = assign(:pagamento_referencia, PagamentoReferencia.create!(
      usuario: "",
      nro_pagamento_referencia: 2,
      id_parceiro: 3,
      valor_pagamento: 4.5,
      terminal_id: "Terminal",
      terminal_location: "Terminal Location",
      terminal_type: "Terminal Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/Terminal/)
    expect(rendered).to match(/Terminal Location/)
    expect(rendered).to match(/Terminal Type/)
  end
end
