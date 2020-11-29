require 'rails_helper'

RSpec.describe "movicel_loops/edit", type: :view do
  before(:each) do
    @movicel_loop = assign(:movicel_loop, MovicelLoop.create!(
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

  it "renders the edit movicel_loop form" do
    render

    assert_select "form[action=?][method=?]", movicel_loop_path(@movicel_loop), "post" do

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
