require 'rails_helper'

RSpec.describe "sms_historico_envios/edit", type: :view do
  before(:each) do
    @sms_historico_envio = assign(:sms_historico_envio, SmsHistoricoEnvio.create!(
      numero: "MyString",
      conteudo: "MyText",
      usuario: nil,
      venda_id: "",
      sucesso: false
    ))
  end

  it "renders the edit sms_historico_envio form" do
    render

    assert_select "form[action=?][method=?]", sms_historico_envio_path(@sms_historico_envio), "post" do

      assert_select "input[name=?]", "sms_historico_envio[numero]"

      assert_select "textarea[name=?]", "sms_historico_envio[conteudo]"

      assert_select "input[name=?]", "sms_historico_envio[usuario_id]"

      assert_select "input[name=?]", "sms_historico_envio[venda_id]"

      assert_select "input[name=?]", "sms_historico_envio[sucesso]"
    end
  end
end
