require 'rails_helper'

RSpec.describe "sequencial_dstvs/new", type: :view do
  before(:each) do
    assign(:sequencial_dstv, SequencialDstv.new(
      :numero => 1
    ))
  end

  it "renders new sequencial_dstv form" do
    render

    assert_select "form[action=?][method=?]", sequencial_dstvs_path, "post" do

      assert_select "input[name=?]", "sequencial_dstv[numero]"
    end
  end
end
