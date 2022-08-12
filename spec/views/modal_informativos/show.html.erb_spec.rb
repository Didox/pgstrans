require 'rails_helper'

RSpec.describe "modal_informativos/show", type: :view do
  before(:each) do
    @modal_informativo = assign(:modal_informativo, ModalInformativo.create!(
      titulo: "Titulo",
      mensagem: "Mensagem",
      validade_inicio: "Validade Inicio",
      validade_fim: "Validade Fim"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/Mensagem/)
    expect(rendered).to match(/Validade Inicio/)
    expect(rendered).to match(/Validade Fim/)
  end
end
