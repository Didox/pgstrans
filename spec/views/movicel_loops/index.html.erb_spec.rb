require 'rails_helper'

RSpec.describe "movicel_loops/index", type: :view do
  before(:each) do
    assign(:movicel_loops, [
      MovicelLoop.create!(
        :usuario => "Usuario",
        :token => "Token",
        :uri => "Uri",
        :ambiente => "Ambiente",
        :agente => "Agente",
        :terminal => "Terminal",
        :valor => 2.5,
        :repeticao => 3,
        :nropedidoinicio => "9.99",
        :nropedido => "9.99",
        :request => "Request",
        :response => "Response"
      ),
      MovicelLoop.create!(
        :usuario => "Usuario",
        :token => "Token",
        :uri => "Uri",
        :ambiente => "Ambiente",
        :agente => "Agente",
        :terminal => "Terminal",
        :valor => 2.5,
        :repeticao => 3,
        :nropedidoinicio => "9.99",
        :nropedido => "9.99",
        :request => "Request",
        :response => "Response"
      )
    ])
  end

  it "renders a list of movicel_loops" do
    render
    assert_select "tr>td", :text => "Usuario".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => "Uri".to_s, :count => 2
    assert_select "tr>td", :text => "Ambiente".to_s, :count => 2
    assert_select "tr>td", :text => "Agente".to_s, :count => 2
    assert_select "tr>td", :text => "Terminal".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    assert_select "tr>td", :text => "Request".to_s, :count => 2
    assert_select "tr>td", :text => "Response".to_s, :count => 2
  end
end
