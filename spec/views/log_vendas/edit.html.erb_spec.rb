require 'rails_helper'

RSpec.describe "log_vendas/edit", type: :view do
  before(:each) do
    @log_venda = assign(:log_venda, LogVenda.create!(
      :titulo => "MyString",
      :log => "MyText"
    ))
  end

  it "renders the edit log_venda form" do
    render

    assert_select "form[action=?][method=?]", log_venda_path(@log_venda), "post" do

      assert_select "input[name=?]", "log_venda[titulo]"

      assert_select "textarea[name=?]", "log_venda[log]"
    end
  end
end
