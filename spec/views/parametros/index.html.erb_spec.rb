require 'rails_helper'

RSpec.describe "parametros/index", type: :view do
  before(:each) do
    assign(:parametros, [
      Parametro.create!(
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
      ),
      Parametro.create!(
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
      )
    ])
  end

  it "renders a list of parametros" do
    render
    assert_select "tr>td", :text => "Url Integracao Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Url Integracao Producao".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Agent Key Movicel Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Key Movicel Producao".to_s, :count => 2
    assert_select "tr>td", :text => "User Id Movicel Desevolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "User Id Movicel Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Data Source Dstv Desevolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Data Source Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Payment Vendor Code Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Payment Vendor Code Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Vendor Code Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Vendor Code Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Account Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Agent Account Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Currency Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Currency Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Product User Key Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Product User Key Dstv Producao".to_s, :count => 2
    assert_select "tr>td", :text => "Mop Dstv Desenvolvimento".to_s, :count => 2
    assert_select "tr>td", :text => "Mop Dstv Producao".to_s, :count => 2
  end
end
