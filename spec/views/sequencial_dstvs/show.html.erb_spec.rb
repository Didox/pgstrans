require 'rails_helper'

RSpec.describe "sequencial_dstvs/show", type: :view do
  before(:each) do
    @sequencial_dstv = assign(:sequencial_dstv, SequencialDstv.create!(
      :numero => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
