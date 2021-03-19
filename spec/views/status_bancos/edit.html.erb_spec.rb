require 'rails_helper'

RSpec.describe "status_bancos/edit", type: :view do
  before(:each) do
    @status_banco = assign(:status_banco, StatusBanco.create!(
      :nome => "MyString"
    ))
  end

  it "renders the edit status_banco form" do
    render

    assert_select "form[action=?][method=?]", status_banco_path(@status_banco), "post" do

      assert_select "input[name=?]", "status_banco[nome]"
    end
  end
end
