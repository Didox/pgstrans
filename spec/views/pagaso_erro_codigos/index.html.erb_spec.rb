require 'rails_helper'

RSpec.describe "pagaso_erro_codigos/index", type: :view do
  before(:each) do
    assign(:pagaso_erro_codigos, [
      PagasoErroCodigo.create!(
        de: "De",
        para: "Para",
        mensagem: "Mensagem"
      ),
      PagasoErroCodigo.create!(
        de: "De",
        para: "Para",
        mensagem: "Mensagem"
      )
    ])
  end

  it "renders a list of pagaso_erro_codigos" do
    render
    assert_select "tr>td", text: "De".to_s, count: 2
    assert_select "tr>td", text: "Para".to_s, count: 2
    assert_select "tr>td", text: "Mensagem".to_s, count: 2
  end
end
