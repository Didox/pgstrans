require 'rails_helper'

RSpec.describe "alteracoes_planos_dstvs/edit", type: :view do
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
      :audit_reference_number => "MyString"
    ))
  end

  it "renders the edit alteracoes_planos_dstv form" do
    render

    assert_select "form[action=?][method=?]", alteracoes_planos_dstv_path(@alteracoes_planos_dstv), "post" do

      assert_select "textarea[name=?]", "alteracoes_planos_dstv[request_body]"

      assert_select "textarea[name=?]", "alteracoes_planos_dstv[response_body]"

      assert_select "textarea[name=?]", "alteracoes_planos_dstv[customer_number]"

      assert_select "textarea[name=?]", "alteracoes_planos_dstv[smartcard]"

      assert_select "textarea[name=?]", "alteracoes_planos_dstv[produto]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[administrador_id]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[produto]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[codigo]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[valor]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[receipt_number]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[transaction_number]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[status]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[transaction_date_time]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[error_message]"

      assert_select "input[name=?]", "alteracoes_planos_dstv[audit_reference_number]"
    end
  end
end
