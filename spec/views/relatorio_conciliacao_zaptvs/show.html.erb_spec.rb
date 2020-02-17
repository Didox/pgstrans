require 'rails_helper'

RSpec.describe "relatorio_conciliacao_zaptvs/show", type: :view do
  before(:each) do
    @relatorio_conciliacao_zaptv = assign(:relatorio_conciliacao_zaptv, RelatorioConciliacaoZaptv.create!(
      :partner => nil,
      :url => "Url",
      :operation_code => "Operation Code",
      :source_reference => "Source Reference",
      :product_code => "",
      :quantity => 2,
      :type => "Type",
      :total_price => 3.5,
      :status => "Status",
      :unit_price => 4.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Operation Code/)
    expect(rendered).to match(/Source Reference/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Type/)
    expect(rendered).to match(/3.5/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/4.5/)
  end
end
