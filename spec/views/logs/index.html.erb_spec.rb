require 'rails_helper'

RSpec.describe "logs/index", type: :view do
  before(:each) do
    assign(:logs, [
      Log.create!(
        :titulo => "Titulo",
        :responsavel => "Responsavel",
        :dados_alterados => "MyText"
      ),
      Log.create!(
        :titulo => "Titulo",
        :responsavel => "Responsavel",
        :dados_alterados => "MyText"
      )
    ])
  end

  it "renders a list of logs" do
    render
    assert_select "tr>td", :text => "Titulo".to_s, :count => 2
    assert_select "tr>td", :text => "Responsavel".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
