require 'rails_helper'

RSpec.describe "unitel_sequences/show", type: :view do
  before(:each) do
    @unitel_sequence = assign(:unitel_sequence, UnitelSequence.create!(
      :sequence_id => 2,
      :venda => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
  end
end
