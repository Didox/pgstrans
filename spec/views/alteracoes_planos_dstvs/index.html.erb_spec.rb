require 'rails_helper'

RSpec.describe "alteracoes_planos_dstvs/index", type: :view do
  before(:each) do
    assign(:alteracoes_planos_dstvs, [
      AlteracoesPlanosDstv.create!(
        :request_body => "MyText",
        :response_body => "MyText",
        :customer_number => "MyText",
        :smartcard => "MyText",
        :produto => "MyText",
        :administrador => nil,
        :produto => "",
        :codigo => "",
        :valor => "",
        :receipt_number => "",
        :transaction_number => "",
        :status => "",
        :transaction_date_time => "",
        :error_message => "",
        :audit_reference_number => "Audit Reference Number"
      ),
      AlteracoesPlanosDstv.create!(
        :request_body => "MyText",
        :response_body => "MyText",
        :customer_number => "MyText",
        :smartcard => "MyText",
        :produto => "MyText",
        :administrador => nil,
        :produto => "",
        :codigo => "",
        :valor => "",
        :receipt_number => "",
        :transaction_number => "",
        :status => "",
        :transaction_date_time => "",
        :error_message => "",
        :audit_reference_number => "Audit Reference Number"
      )
    ])
  end

  it "renders a list of alteracoes_planos_dstvs" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Audit Reference Number".to_s, :count => 2
  end
end
