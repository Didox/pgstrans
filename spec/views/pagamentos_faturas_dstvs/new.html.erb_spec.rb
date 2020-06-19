require 'rails_helper'

RSpec.describe "pagamentos_faturas_dstvs/new", type: :view do
  before(:each) do
    assign(:pagamentos_faturas_dstv, PagamentosFaturasDstv.new(
      :request_body => "MyText",
      :response_body => "MyText",
      :customer_number => "MyString",
      :valor => 1.5,
      :smartcard => "MyString",
      :administrador => nil,
      :receipt_number => "MyString",
      :transaction_number => "MyString",
      :status => "MyString",
      :transaction_date_time => "MyString",
      :audit_reference_number => "MyString"
    ))
  end

  it "renders new pagamentos_faturas_dstv form" do
    render

    assert_select "form[action=?][method=?]", pagamentos_faturas_dstvs_path, "post" do

      assert_select "textarea[name=?]", "pagamentos_faturas_dstv[request_body]"

      assert_select "textarea[name=?]", "pagamentos_faturas_dstv[response_body]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[customer_number]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[valor]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[smartcard]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[administrador_id]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[receipt_number]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[transaction_number]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[status]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[transaction_date_time]"

      assert_select "input[name=?]", "pagamentos_faturas_dstv[audit_reference_number]"
    end
  end
end
