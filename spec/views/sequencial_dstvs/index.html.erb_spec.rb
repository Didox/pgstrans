require 'rails_helper'

RSpec.describe "sequencial_dstvs/index", type: :view do
  before(:each) do
    assign(:sequencial_dstvs, [
      SequencialDstv.create!(
        :numero => 2
      ),
      SequencialDstv.create!(
        :numero => 2
      )
    ])
  end

  it "renders a list of sequencial_dstvs" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
