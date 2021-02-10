require 'rails_helper'

RSpec.describe "erro_amigavels/index", type: :view do
  before(:each) do
    assign(:erro_amigavels, [
      ErroAmigavel.create!(
        :de => "De",
        :para => "Para"
      ),
      ErroAmigavel.create!(
        :de => "De",
        :para => "Para"
      )
    ])
  end

  it "renders a list of erro_amigavels" do
    render
    assert_select "tr>td", :text => "De".to_s, :count => 2
    assert_select "tr>td", :text => "Para".to_s, :count => 2
  end
end
