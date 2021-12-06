require 'rails_helper'

RSpec.describe "ip_api_autorizados/new", type: :view do
  before(:each) do
    assign(:ip_api_autorizado, IpApiAutorizado.new(
      ip: "MyString",
      sub_distribuidor: nil
    ))
  end

  it "renders new ip_api_autorizado form" do
    render

    assert_select "form[action=?][method=?]", ip_api_autorizados_path, "post" do

      assert_select "input[name=?]", "ip_api_autorizado[ip]"

      assert_select "input[name=?]", "ip_api_autorizado[sub_distribuidor_id]"
    end
  end
end
