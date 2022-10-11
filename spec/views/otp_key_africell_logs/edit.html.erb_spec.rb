require 'rails_helper'

RSpec.describe "otp_key_africell_logs/edit", type: :view do
  before(:each) do
    @otp_key_africell_log = assign(:otp_key_africell_log, OtpKeyAfricellLog.create!(
      log: "MyString"
    ))
  end

  it "renders the edit otp_key_africell_log form" do
    render

    assert_select "form[action=?][method=?]", otp_key_africell_log_path(@otp_key_africell_log), "post" do

      assert_select "input[name=?]", "otp_key_africell_log[log]"
    end
  end
end
