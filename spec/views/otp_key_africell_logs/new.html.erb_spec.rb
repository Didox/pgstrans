require 'rails_helper'

RSpec.describe "otp_key_africell_logs/new", type: :view do
  before(:each) do
    assign(:otp_key_africell_log, OtpKeyAfricellLog.new(
      log: "MyString"
    ))
  end

  it "renders new otp_key_africell_log form" do
    render

    assert_select "form[action=?][method=?]", otp_key_africell_logs_path, "post" do

      assert_select "input[name=?]", "otp_key_africell_log[log]"
    end
  end
end
