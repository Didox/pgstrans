require 'rails_helper'

RSpec.describe "ip_api_autorizados/index", type: :view do
  before(:each) do
    assign(:ip_api_autorizados, [
      IpApiAutorizado.create!(
        ip: "Ip",
        sub_distribuidor: nil
      ),
      IpApiAutorizado.create!(
        ip: "Ip",
        sub_distribuidor: nil
      )
    ])
  end

  it "renders a list of ip_api_autorizados" do
    render
    assert_select "tr>td", text: "Ip".to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
  end
end
