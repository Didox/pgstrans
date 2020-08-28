require 'rails_helper'

RSpec.describe "desconto_parceiros/edit", type: :view do
  before(:each) do
    @desconto_parceiro = assign(:desconto_parceiro, DescontoParceiro.create!(
      :porcentagem => 1.5,
      :partner => nil
    ))
  end

  it "renders the edit desconto_parceiro form" do
    render

    assert_select "form[action=?][method=?]", desconto_parceiro_path(@desconto_parceiro), "post" do

      assert_select "input[name=?]", "desconto_parceiro[porcentagem]"

      assert_select "input[name=?]", "desconto_parceiro[partner_id]"
    end
  end
end
