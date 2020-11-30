require 'rails_helper'

RSpec.describe "loop_logs/index", type: :view do
  before(:each) do
    assign(:loop_logs, [
      LoopLog.create!(
        :request => "MyText",
        :response => "MyText",
        :movicel_loop => nil
      ),
      LoopLog.create!(
        :request => "MyText",
        :response => "MyText",
        :movicel_loop => nil
      )
    ])
  end

  it "renders a list of loop_logs" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
