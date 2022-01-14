require 'rails_helper'

RSpec.describe "email_historico_envios/edit", type: :view do
  before(:each) do
    @email_historico_envio = assign(:email_historico_envio, EmailHistoricoEnvio.create!(
      email: "MyString",
      titulo: "MyString",
      conteudo: "MyText",
      usuario: nil,
      venda_id: "",
      sucesso: false
    ))
  end

  it "renders the edit email_historico_envio form" do
    render

    assert_select "form[action=?][method=?]", email_historico_envio_path(@email_historico_envio), "post" do

      assert_select "input[name=?]", "email_historico_envio[email]"

      assert_select "input[name=?]", "email_historico_envio[titulo]"

      assert_select "textarea[name=?]", "email_historico_envio[conteudo]"

      assert_select "input[name=?]", "email_historico_envio[usuario_id]"

      assert_select "input[name=?]", "email_historico_envio[venda_id]"

      assert_select "input[name=?]", "email_historico_envio[sucesso]"
    end
  end
end
