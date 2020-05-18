require 'rails_helper'

RSpec.describe "grupos/edit", type: :view do
  before(:each) do
    @grupo = assign(:grupo, Grupo.create!(
      :nome => "MyString",
      :descricao => "MyText"
    ))
  end

  it "renders the edit grupo form" do
    render

    assert_select "form[action=?][method=?]", grupo_path(@grupo), "post" do

      assert_select "input[name=?]", "grupo[nome]"

      assert_select "textarea[name=?]", "grupo[descricao]"
    end
  end
end
