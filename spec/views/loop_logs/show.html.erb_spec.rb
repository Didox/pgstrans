require 'rails_helper'

RSpec.describe "loop_logs/show", type: :view do
  before(:each) do
    @loop_log = assign(:loop_log, LoopLog.create!(
      :request => "MyText",
      :response => "MyText",
      :movicel_loop => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
