require 'rails_helper'

RSpec.describe "otp_key_africell_logs/index", type: :view do
  before(:each) do
    assign(:otp_key_africell_logs, [
      OtpKeyAfricellLog.create!(
        log: "Log"
      ),
      OtpKeyAfricellLog.create!(
        log: "Log"
      )
    ])
  end

  it "renders a list of otp_key_africell_logs" do
    render
    assert_select "tr>td", text: "Log".to_s, count: 2
  end
end
