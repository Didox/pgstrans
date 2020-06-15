require 'rails_helper'

RSpec.describe "log_vendas/index", type: :view do
  before(:each) do
    assign(:log_vendas, [
      LogVenda.create!(
        :titulo => "Titulo",
        :log => "MyText"
      ),
      LogVenda.create!(
        :titulo => "Titulo",
        :log => "MyText"
      )
    ])
  end

  it "renders a list of log_vendas" do
    render
    assert_select "tr>td", :text => "Titulo".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
