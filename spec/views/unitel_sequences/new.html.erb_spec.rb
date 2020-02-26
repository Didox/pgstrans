require 'rails_helper'

RSpec.describe "unitel_sequences/new", type: :view do
  before(:each) do
    assign(:unitel_sequence, UnitelSequence.new(
      :sequence_id => 1,
      :venda => nil
    ))
  end

  it "renders new unitel_sequence form" do
    render

    assert_select "form[action=?][method=?]", unitel_sequences_path, "post" do

      assert_select "input[name=?]", "unitel_sequence[sequence_id]"

      assert_select "input[name=?]", "unitel_sequence[venda_id]"
    end
  end
end
