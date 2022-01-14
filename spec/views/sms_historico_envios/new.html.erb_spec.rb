require 'rails_helper'

RSpec.describe "sms_historico_envios/new", type: :view do
  before(:each) do
    assign(:sms_historico_envio, SmsHistoricoEnvio.new(
      numero: "MyString",
      conteudo: "MyText",
      usuario: nil,
      venda_id: "",
      sucesso: false
    ))
  end

  it "renders new sms_historico_envio form" do
    render

    assert_select "form[action=?][method=?]", sms_historico_envios_path, "post" do

      assert_select "input[name=?]", "sms_historico_envio[numero]"

      assert_select "textarea[name=?]", "sms_historico_envio[conteudo]"

      assert_select "input[name=?]", "sms_historico_envio[usuario_id]"

      assert_select "input[name=?]", "sms_historico_envio[venda_id]"

      assert_select "input[name=?]", "sms_historico_envio[sucesso]"
    end
  end
end
