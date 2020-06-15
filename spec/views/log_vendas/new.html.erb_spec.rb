require 'rails_helper'

RSpec.describe "log_vendas/new", type: :view do
  before(:each) do
    assign(:log_venda, LogVenda.new(
      :titulo => "MyString",
      :log => "MyText"
    ))
  end

  it "renders new log_venda form" do
    render

    assert_select "form[action=?][method=?]", log_vendas_path, "post" do

      assert_select "input[name=?]", "log_venda[titulo]"

      assert_select "textarea[name=?]", "log_venda[log]"
    end
  end
end
