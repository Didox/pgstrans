require 'rails_helper'

RSpec.describe "parametros/edit", type: :view do
  before(:each) do
    @parametro = assign(:parametro, Parametro.create!(
      :url_integracao_desenvolvimento => "MyString",
      :url_integracao_producao => "MyString",
      :partner => nil,
      :agent_key_movicel_desenvolvimento => "MyString",
      :agent_key_movicel_producao => "MyString",
      :user_id_movicel_desevolvimento => "MyString",
      :user_id_movicel_producao => "MyString",
      :data_source_dstv_desevolvimento => "MyString",
      :data_source_dstv_producao => "MyString",
      :payment_vendor_code_dstv_desenvolvimento => "MyString",
      :payment_vendor_code_dstv_producao => "MyString",
      :vendor_code_dstv_desenvolvimento => "MyString",
      :vendor_code_dstv_producao => "MyString",
      :agent_account_dstv_desenvolvimento => "MyString",
      :agent_account_dstv_producao => "MyString",
      :currency_dstv_desenvolvimento => "MyString",
      :currency_dstv_producao => "MyString",
      :product_user_key_dstv_desenvolvimento => "MyString",
      :product_user_key_dstv_producao => "MyString",
      :mop_dstv_desenvolvimento => "MyString",
      :mop_dstv_producao => "MyString"
    ))
  end

  it "renders the edit parametro form" do
    render

    assert_select "form[action=?][method=?]", parametro_path(@parametro), "post" do

      assert_select "input[name=?]", "parametro[url_integracao_desenvolvimento]"

      assert_select "input[name=?]", "parametro[url_integracao_producao]"

      assert_select "input[name=?]", "parametro[partner_id]"

      assert_select "input[name=?]", "parametro[agent_key_movicel_desenvolvimento]"

      assert_select "input[name=?]", "parametro[agent_key_movicel_producao]"

      assert_select "input[name=?]", "parametro[user_id_movicel_desevolvimento]"

      assert_select "input[name=?]", "parametro[user_id_movicel_producao]"

      assert_select "input[name=?]", "parametro[data_source_dstv_desevolvimento]"

      assert_select "input[name=?]", "parametro[data_source_dstv_producao]"

      assert_select "input[name=?]", "parametro[payment_vendor_code_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[payment_vendor_code_dstv_producao]"

      assert_select "input[name=?]", "parametro[vendor_code_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[vendor_code_dstv_producao]"

      assert_select "input[name=?]", "parametro[agent_account_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[agent_account_dstv_producao]"

      assert_select "input[name=?]", "parametro[currency_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[currency_dstv_producao]"

      assert_select "input[name=?]", "parametro[product_user_key_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[product_user_key_dstv_producao]"

      assert_select "input[name=?]", "parametro[mop_dstv_desenvolvimento]"

      assert_select "input[name=?]", "parametro[mop_dstv_producao]"
    end
  end
end
