require 'rails_helper'

RSpec.describe "alteracoes_planos_dstvs/show", type: :view do
  before(:each) do
    @alteracoes_planos_dstv = assign(:alteracoes_planos_dstv, AlteracoesPlanosDstv.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Audit Reference Number/)
  end
end
