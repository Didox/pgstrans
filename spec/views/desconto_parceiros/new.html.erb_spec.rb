require 'rails_helper'

RSpec.describe "desconto_parceiros/new", type: :view do
  before(:each) do
    assign(:desconto_parceiro, DescontoParceiro.new(
      :porcentagem => 1.5,
      :partner => nil
    ))
  end

  it "renders new desconto_parceiro form" do
    render

    assert_select "form[action=?][method=?]", desconto_parceiros_path, "post" do

      assert_select "input[name=?]", "desconto_parceiro[porcentagem]"

      assert_select "input[name=?]", "desconto_parceiro[partner_id]"
    end
  end
end
