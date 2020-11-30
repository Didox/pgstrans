require 'rails_helper'

RSpec.describe "loop_logs/edit", type: :view do
  before(:each) do
    @loop_log = assign(:loop_log, LoopLog.create!(
      :request => "MyText",
      :response => "MyText",
      :movicel_loop => nil
    ))
  end

  it "renders the edit loop_log form" do
    render

    assert_select "form[action=?][method=?]", loop_log_path(@loop_log), "post" do

      assert_select "textarea[name=?]", "loop_log[request]"

      assert_select "textarea[name=?]", "loop_log[response]"

      assert_select "input[name=?]", "loop_log[movicel_loop_id]"
    end
  end
end
