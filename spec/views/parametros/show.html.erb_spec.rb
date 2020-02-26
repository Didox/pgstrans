require 'rails_helper'

RSpec.describe "parametros/show", type: :view do
  before(:each) do
    @parametro = assign(:parametro, Parametro.create!(
      :url_integracao_desenvolvimento => "Url Integracao Desenvolvimento",
      :url_integracao_producao => "Url Integracao Producao",
      :partner => nil,
      :agent_key_movicel_desenvolvimento => "Agent Key Movicel Desenvolvimento",
      :agent_key_movicel_producao => "Agent Key Movicel Producao",
      :user_id_movicel_desevolvimento => "User Id Movicel Desevolvimento",
      :user_id_movicel_producao => "User Id Movicel Producao",
      :data_source_dstv_desevolvimento => "Data Source Dstv Desevolvimento",
      :data_source_dstv_producao => "Data Source Dstv Producao",
      :payment_vendor_code_dstv_desenvolvimento => "Payment Vendor Code Dstv Desenvolvimento",
      :payment_vendor_code_dstv_producao => "Payment Vendor Code Dstv Producao",
      :vendor_code_dstv_desenvolvimento => "Vendor Code Dstv Desenvolvimento",
      :vendor_code_dstv_producao => "Vendor Code Dstv Producao",
      :agent_account_dstv_desenvolvimento => "Agent Account Dstv Desenvolvimento",
      :agent_account_dstv_producao => "Agent Account Dstv Producao",
      :currency_dstv_desenvolvimento => "Currency Dstv Desenvolvimento",
      :currency_dstv_producao => "Currency Dstv Producao",
      :product_user_key_dstv_desenvolvimento => "Product User Key Dstv Desenvolvimento",
      :product_user_key_dstv_producao => "Product User Key Dstv Producao",
      :mop_dstv_desenvolvimento => "Mop Dstv Desenvolvimento",
      :mop_dstv_producao => "Mop Dstv Producao"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Url Integracao Desenvolvimento/)
    expect(rendered).to match(/Url Integracao Producao/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Agent Key Movicel Desenvolvimento/)
    expect(rendered).to match(/Agent Key Movicel Producao/)
    expect(rendered).to match(/User Id Movicel Desevolvimento/)
    expect(rendered).to match(/User Id Movicel Producao/)
    expect(rendered).to match(/Data Source Dstv Desevolvimento/)
    expect(rendered).to match(/Data Source Dstv Producao/)
    expect(rendered).to match(/Payment Vendor Code Dstv Desenvolvimento/)
    expect(rendered).to match(/Payment Vendor Code Dstv Producao/)
    expect(rendered).to match(/Vendor Code Dstv Desenvolvimento/)
    expect(rendered).to match(/Vendor Code Dstv Producao/)
    expect(rendered).to match(/Agent Account Dstv Desenvolvimento/)
    expect(rendered).to match(/Agent Account Dstv Producao/)
    expect(rendered).to match(/Currency Dstv Desenvolvimento/)
    expect(rendered).to match(/Currency Dstv Producao/)
    expect(rendered).to match(/Product User Key Dstv Desenvolvimento/)
    expect(rendered).to match(/Product User Key Dstv Producao/)
    expect(rendered).to match(/Mop Dstv Desenvolvimento/)
    expect(rendered).to match(/Mop Dstv Producao/)
  end
end
