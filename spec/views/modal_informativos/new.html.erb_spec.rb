require 'rails_helper'

RSpec.describe "modal_informativos/new", type: :view do
  before(:each) do
    assign(:modal_informativo, ModalInformativo.new(
      titulo: "MyString",
      mensagem: "MyString",
      validade_inicio: "MyString",
      validade_fim: "MyString"
    ))
  end

  it "renders new modal_informativo form" do
    render

    assert_select "form[action=?][method=?]", modal_informativos_path, "post" do

      assert_select "input[name=?]", "modal_informativo[titulo]"

      assert_select "input[name=?]", "modal_informativo[mensagem]"

      assert_select "input[name=?]", "modal_informativo[validade_inicio]"

      assert_select "input[name=?]", "modal_informativo[validade_fim]"
    end
  end
end
