require 'rails_helper'

RSpec.describe "sequencial_dstvs/edit", type: :view do
  before(:each) do
    @sequencial_dstv = assign(:sequencial_dstv, SequencialDstv.create!(
      :numero => 1
    ))
  end

  it "renders the edit sequencial_dstv form" do
    render

    assert_select "form[action=?][method=?]", sequencial_dstv_path(@sequencial_dstv), "post" do

      assert_select "input[name=?]", "sequencial_dstv[numero]"
    end
  end
end
