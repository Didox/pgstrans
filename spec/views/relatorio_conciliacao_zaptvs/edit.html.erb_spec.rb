require 'rails_helper'

RSpec.describe "relatorio_conciliacao_zaptvs/edit", type: :view do
  before(:each) do
    @relatorio_conciliacao_zaptv = assign(:relatorio_conciliacao_zaptv, RelatorioConciliacaoZaptv.create!(
      :partner => nil,
      :url => "MyString",
      :operation_code => "MyString",
      :source_reference => "MyString",
      :product_code => "",
      :quantity => 1,
      :type => "",
      :total_price => 1.5,
      :status => "MyString",
      :unit_price => 1.5
    ))
  end

  it "renders the edit relatorio_conciliacao_zaptv form" do
    render

    assert_select "form[action=?][method=?]", relatorio_conciliacao_zaptv_path(@relatorio_conciliacao_zaptv), "post" do

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[partner_id]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[url]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[operation_code]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[source_reference]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[product_code]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[quantity]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[type]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[total_price]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[status]"

      assert_select "input[name=?]", "relatorio_conciliacao_zaptv[unit_price]"
    end
  end
end
