require 'rails_helper'

RSpec.describe "unitel_sequences/edit", type: :view do
  before(:each) do
    @unitel_sequence = assign(:unitel_sequence, UnitelSequence.create!(
      :sequence_id => 1,
      :venda => nil
    ))
  end

  it "renders the edit unitel_sequence form" do
    render

    assert_select "form[action=?][method=?]", unitel_sequence_path(@unitel_sequence), "post" do

      assert_select "input[name=?]", "unitel_sequence[sequence_id]"

      assert_select "input[name=?]", "unitel_sequence[venda_id]"
    end
  end
end
