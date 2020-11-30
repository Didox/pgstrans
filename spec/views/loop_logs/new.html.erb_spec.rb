require 'rails_helper'

RSpec.describe "loop_logs/new", type: :view do
  before(:each) do
    assign(:loop_log, LoopLog.new(
      :request => "MyText",
      :response => "MyText",
      :movicel_loop => nil
    ))
  end

  it "renders new loop_log form" do
    render

    assert_select "form[action=?][method=?]", loop_logs_path, "post" do

      assert_select "textarea[name=?]", "loop_log[request]"

      assert_select "textarea[name=?]", "loop_log[response]"

      assert_select "input[name=?]", "loop_log[movicel_loop_id]"
    end
  end
end
