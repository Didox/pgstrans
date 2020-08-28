require 'rails_helper'

RSpec.describe "desconto_parceiros/index", type: :view do
  before(:each) do
    assign(:desconto_parceiros, [
      DescontoParceiro.create!(
        :porcentagem => 2.5,
        :partner => nil
      ),
      DescontoParceiro.create!(
        :porcentagem => 2.5,
        :partner => nil
      )
    ])
  end

  it "renders a list of desconto_parceiros" do
    render
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
