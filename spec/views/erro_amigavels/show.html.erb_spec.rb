require 'rails_helper'

RSpec.describe "erro_amigavels/show", type: :view do
  before(:each) do
    @erro_amigavel = assign(:erro_amigavel, ErroAmigavel.create!(
      :de => "De",
      :para => "Para"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/De/)
    expect(rendered).to match(/Para/)
  end
end
