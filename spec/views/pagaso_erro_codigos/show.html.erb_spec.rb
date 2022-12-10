require 'rails_helper'

RSpec.describe "pagaso_erro_codigos/show", type: :view do
  before(:each) do
    @pagaso_erro_codigo = assign(:pagaso_erro_codigo, PagasoErroCodigo.create!(
      de: "De",
      para: "Para",
      mensagem: "Mensagem"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/De/)
    expect(rendered).to match(/Para/)
    expect(rendered).to match(/Mensagem/)
  end
end
