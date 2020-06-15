require 'rails_helper'

RSpec.describe "log_vendas/show", type: :view do
  before(:each) do
    @log_venda = assign(:log_venda, LogVenda.create!(
      :titulo => "Titulo",
      :log => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/MyText/)
  end
end
