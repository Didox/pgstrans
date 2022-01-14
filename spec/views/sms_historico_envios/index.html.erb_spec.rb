require 'rails_helper'

RSpec.describe "sms_historico_envios/index", type: :view do
  before(:each) do
    assign(:sms_historico_envios, [
      SmsHistoricoEnvio.create!(
        numero: "Numero",
        conteudo: "MyText",
        usuario: nil,
        venda_id: "",
        sucesso: false
      ),
      SmsHistoricoEnvio.create!(
        numero: "Numero",
        conteudo: "MyText",
        usuario: nil,
        venda_id: "",
        sucesso: false
      )
    ])
  end

  it "renders a list of sms_historico_envios" do
    render
    assert_select "tr>td", text: "Numero".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
