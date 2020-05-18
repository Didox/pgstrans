require 'rails_helper'

RSpec.describe "grupos/new", type: :view do
  before(:each) do
    assign(:grupo, Grupo.new(
      :nome => "MyString",
      :descricao => "MyText"
    ))
  end

  it "renders new grupo form" do
    render

    assert_select "form[action=?][method=?]", grupos_path, "post" do

      assert_select "input[name=?]", "grupo[nome]"

      assert_select "textarea[name=?]", "grupo[descricao]"
    end
  end
end
