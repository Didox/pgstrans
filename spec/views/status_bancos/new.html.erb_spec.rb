require 'rails_helper'

RSpec.describe "status_bancos/new", type: :view do
  before(:each) do
    assign(:status_banco, StatusBanco.new(
      :nome => "MyString"
    ))
  end

  it "renders new status_banco form" do
    render

    assert_select "form[action=?][method=?]", status_bancos_path, "post" do

      assert_select "input[name=?]", "status_banco[nome]"
    end
  end
end
