require 'rails_helper'

RSpec.describe "modal_informativos/edit", type: :view do
  before(:each) do
    @modal_informativo = assign(:modal_informativo, ModalInformativo.create!(
      titulo: "MyString",
      mensagem: "MyString",
      validade_inicio: "MyString",
      validade_fim: "MyString"
    ))
  end

  it "renders the edit modal_informativo form" do
    render

    assert_select "form[action=?][method=?]", modal_informativo_path(@modal_informativo), "post" do

      assert_select "input[name=?]", "modal_informativo[titulo]"

      assert_select "input[name=?]", "modal_informativo[mensagem]"

      assert_select "input[name=?]", "modal_informativo[validade_inicio]"

      assert_select "input[name=?]", "modal_informativo[validade_fim]"
    end
  end
end
