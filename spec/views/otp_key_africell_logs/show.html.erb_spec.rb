require 'rails_helper'

RSpec.describe "otp_key_africell_logs/show", type: :view do
  before(:each) do
    @otp_key_africell_log = assign(:otp_key_africell_log, OtpKeyAfricellLog.create!(
      log: "Log"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Log/)
  end
end
