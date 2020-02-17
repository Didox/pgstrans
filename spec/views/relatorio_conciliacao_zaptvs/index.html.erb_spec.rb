require 'rails_helper'

RSpec.describe "relatorio_conciliacao_zaptvs/index", type: :view do
  before(:each) do
    assign(:relatorio_conciliacao_zaptvs, [
      RelatorioConciliacaoZaptv.create!(
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
      ),
      RelatorioConciliacaoZaptv.create!(
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
      )
    ])
  end

  it "renders a list of relatorio_conciliacao_zaptvs" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Operation Code".to_s, :count => 2
    assert_select "tr>td", :text => "Source Reference".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 3.5.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => 4.5.to_s, :count => 2
  end
end
