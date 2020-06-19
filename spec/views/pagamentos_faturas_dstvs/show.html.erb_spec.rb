require 'rails_helper'

RSpec.describe "pagamentos_faturas_dstvs/show", type: :view do
  before(:each) do
    @pagamentos_faturas_dstv = assign(:pagamentos_faturas_dstv, PagamentosFaturasDstv.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Customer Number/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/Smartcard/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Receipt Number/)
    expect(rendered).to match(/Transaction Number/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Transaction Date Time/)
    expect(rendered).to match(/Audit Reference Number/)
  end
end
