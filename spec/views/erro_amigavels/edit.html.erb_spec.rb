require 'rails_helper'

RSpec.describe "erro_amigavels/edit", type: :view do
  before(:each) do
    @erro_amigavel = assign(:erro_amigavel, ErroAmigavel.create!(
      :de => "MyString",
      :para => "MyString"
    ))
  end

  it "renders the edit erro_amigavel form" do
    render

    assert_select "form[action=?][method=?]", erro_amigavel_path(@erro_amigavel), "post" do

      assert_select "input[name=?]", "erro_amigavel[de]"

      assert_select "input[name=?]", "erro_amigavel[para]"
    end
  end
end
