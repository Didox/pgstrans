require 'rails_helper'

RSpec.describe "erro_amigavels/new", type: :view do
  before(:each) do
    assign(:erro_amigavel, ErroAmigavel.new(
      :de => "MyString",
      :para => "MyString"
    ))
  end

  it "renders new erro_amigavel form" do
    render

    assert_select "form[action=?][method=?]", erro_amigavels_path, "post" do

      assert_select "input[name=?]", "erro_amigavel[de]"

      assert_select "input[name=?]", "erro_amigavel[para]"
    end
  end
end
