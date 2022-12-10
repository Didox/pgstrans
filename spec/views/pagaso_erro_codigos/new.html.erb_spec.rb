require 'rails_helper'

RSpec.describe "pagaso_erro_codigos/new", type: :view do
  before(:each) do
    assign(:pagaso_erro_codigo, PagasoErroCodigo.new(
      de: "MyString",
      para: "MyString",
      mensagem: "MyString"
    ))
  end

  it "renders new pagaso_erro_codigo form" do
    render

    assert_select "form[action=?][method=?]", pagaso_erro_codigos_path, "post" do

      assert_select "input[name=?]", "pagaso_erro_codigo[de]"

      assert_select "input[name=?]", "pagaso_erro_codigo[para]"

      assert_select "input[name=?]", "pagaso_erro_codigo[mensagem]"
    end
  end
end
