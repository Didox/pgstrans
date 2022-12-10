require 'rails_helper'

RSpec.describe "pagaso_erro_codigos/edit", type: :view do
  before(:each) do
    @pagaso_erro_codigo = assign(:pagaso_erro_codigo, PagasoErroCodigo.create!(
      de: "MyString",
      para: "MyString",
      mensagem: "MyString"
    ))
  end

  it "renders the edit pagaso_erro_codigo form" do
    render

    assert_select "form[action=?][method=?]", pagaso_erro_codigo_path(@pagaso_erro_codigo), "post" do

      assert_select "input[name=?]", "pagaso_erro_codigo[de]"

      assert_select "input[name=?]", "pagaso_erro_codigo[para]"

      assert_select "input[name=?]", "pagaso_erro_codigo[mensagem]"
    end
  end
end
