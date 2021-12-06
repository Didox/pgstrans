require 'rails_helper'

RSpec.describe "ip_api_autorizados/edit", type: :view do
  before(:each) do
    @ip_api_autorizado = assign(:ip_api_autorizado, IpApiAutorizado.create!(
      ip: "MyString",
      sub_distribuidor: nil
    ))
  end

  it "renders the edit ip_api_autorizado form" do
    render

    assert_select "form[action=?][method=?]", ip_api_autorizado_path(@ip_api_autorizado), "post" do

      assert_select "input[name=?]", "ip_api_autorizado[ip]"

      assert_select "input[name=?]", "ip_api_autorizado[sub_distribuidor_id]"
    end
  end
end
