require 'rails_helper'

RSpec.describe "email_historico_envios/index", type: :view do
  before(:each) do
    assign(:email_historico_envios, [
      EmailHistoricoEnvio.create!(
        email: "Email",
        titulo: "Titulo",
        conteudo: "MyText",
        usuario: nil,
        venda_id: "",
        sucesso: false
      ),
      EmailHistoricoEnvio.create!(
        email: "Email",
        titulo: "Titulo",
        conteudo: "MyText",
        usuario: nil,
        venda_id: "",
        sucesso: false
      )
    ])
  end

  it "renders a list of email_historico_envios" do
    render
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: "Titulo".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
