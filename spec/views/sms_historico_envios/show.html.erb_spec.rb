require 'rails_helper'

RSpec.describe "sms_historico_envios/show", type: :view do
  before(:each) do
    @sms_historico_envio = assign(:sms_historico_envio, SmsHistoricoEnvio.create!(
      numero: "Numero",
      conteudo: "MyText",
      usuario: nil,
      venda_id: "",
      sucesso: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Numero/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
