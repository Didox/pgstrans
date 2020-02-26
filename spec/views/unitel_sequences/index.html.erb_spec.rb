require 'rails_helper'

RSpec.describe "unitel_sequences/index", type: :view do
  before(:each) do
    assign(:unitel_sequences, [
      UnitelSequence.create!(
        :sequence_id => 2,
        :venda => nil
      ),
      UnitelSequence.create!(
        :sequence_id => 2,
        :venda => nil
      )
    ])
  end

  it "renders a list of unitel_sequences" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
