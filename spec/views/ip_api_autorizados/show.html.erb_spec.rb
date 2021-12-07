require 'rails_helper'

RSpec.describe "ip_api_autorizados/show", type: :view do
  before(:each) do
    @ip_api_autorizado = assign(:ip_api_autorizado, IpApiAutorizado.create!(
      ip: "Ip",
      sub_distribuidor: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Ip/)
    expect(rendered).to match(//)
  end
end
