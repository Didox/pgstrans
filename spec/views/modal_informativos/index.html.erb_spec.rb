require 'rails_helper'

RSpec.describe "modal_informativos/index", type: :view do
  before(:each) do
    assign(:modal_informativos, [
      ModalInformativo.create!(
        titulo: "Titulo",
        mensagem: "Mensagem",
        validade_inicio: "Validade Inicio",
        validade_fim: "Validade Fim"
      ),
      ModalInformativo.create!(
        titulo: "Titulo",
        mensagem: "Mensagem",
        validade_inicio: "Validade Inicio",
        validade_fim: "Validade Fim"
      )
    ])
  end

  it "renders a list of modal_informativos" do
    render
    assert_select "tr>td", text: "Titulo".to_s, count: 2
    assert_select "tr>td", text: "Mensagem".to_s, count: 2
    assert_select "tr>td", text: "Validade Inicio".to_s, count: 2
    assert_select "tr>td", text: "Validade Fim".to_s, count: 2
  end
end
