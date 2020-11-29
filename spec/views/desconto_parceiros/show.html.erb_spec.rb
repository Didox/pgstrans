require 'rails_helper'

RSpec.describe "desconto_parceiros/show", type: :view do
  before(:each) do
    @desconto_parceiro = assign(:desconto_parceiro, DescontoParceiro.create!(
      :porcentagem => 2.5,
      :partner => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(//)
  end
end
