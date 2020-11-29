require 'rails_helper'

RSpec.describe "movicel_loops/new", type: :view do
  before(:each) do
    assign(:movicel_loop, MovicelLoop.new(
      :usuario => "MyString",
      :token => "MyString",
      :uri => "MyString",
      :ambiente => "MyString",
      :agente => "MyString",
      :terminal => "MyString",
      :valor => 1.5,
      :repeticao => 1,
      :nropedidoinicio => "9.99",
      :nropedido => "9.99",
      :request => "MyString",
      :response => "MyString"
    ))
  end

  it "renders new movicel_loop form" do
    render

    assert_select "form[action=?][method=?]", movicel_loops_path, "post" do

      assert_select "input[name=?]", "movicel_loop[usuario]"

      assert_select "input[name=?]", "movicel_loop[token]"

      assert_select "input[name=?]", "movicel_loop[uri]"

      assert_select "input[name=?]", "movicel_loop[ambiente]"

      assert_select "input[name=?]", "movicel_loop[agente]"

      assert_select "input[name=?]", "movicel_loop[terminal]"

      assert_select "input[name=?]", "movicel_loop[valor]"

      assert_select "input[name=?]", "movicel_loop[repeticao]"

      assert_select "input[name=?]", "movicel_loop[nropedidoinicio]"

      assert_select "input[name=?]", "movicel_loop[nropedido]"

      assert_select "input[name=?]", "movicel_loop[request]"

      assert_select "input[name=?]", "movicel_loop[response]"
    end
  end
end
