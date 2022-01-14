require 'rails_helper'

RSpec.describe "email_historico_envios/show", type: :view do
  before(:each) do
    @email_historico_envio = assign(:email_historico_envio, EmailHistoricoEnvio.create!(
      email: "Email",
      titulo: "Titulo",
      conteudo: "MyText",
      usuario: nil,
      venda_id: "",
      sucesso: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
