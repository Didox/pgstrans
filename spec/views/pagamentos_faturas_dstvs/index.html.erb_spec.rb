require 'rails_helper'

RSpec.describe "pagamentos_faturas_dstvs/index", type: :view do
  before(:each) do
    assign(:pagamentos_faturas_dstvs, [
      PagamentosFaturasDstv.create!(
        :request_body => "MyText",
        :response_body => "MyText",
        :customer_number => "Customer Number",
        :valor => 2.5,
        :smartcard => "Smartcard",
        :administrador => nil,
        :receipt_number => "Receipt Number",
        :transaction_number => "Transaction Number",
        :status => "Status",
        :transaction_date_time => "Transaction Date Time",
        :audit_reference_number => "Audit Reference Number"
      ),
      PagamentosFaturasDstv.create!(
        :request_body => "MyText",
        :response_body => "MyText",
        :customer_number => "Customer Number",
        :valor => 2.5,
        :smartcard => "Smartcard",
        :administrador => nil,
        :receipt_number => "Receipt Number",
        :transaction_number => "Transaction Number",
        :status => "Status",
        :transaction_date_time => "Transaction Date Time",
        :audit_reference_number => "Audit Reference Number"
      )
    ])
  end

  it "renders a list of pagamentos_faturas_dstvs" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Customer Number".to_s, :count => 2
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "Smartcard".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Receipt Number".to_s, :count => 2
    assert_select "tr>td", :text => "Transaction Number".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Transaction Date Time".to_s, :count => 2
    assert_select "tr>td", :text => "Audit Reference Number".to_s, :count => 2
  end
end
