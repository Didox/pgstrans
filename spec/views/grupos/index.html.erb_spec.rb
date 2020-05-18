require 'rails_helper'

RSpec.describe "grupos/index", type: :view do
  before(:each) do
    assign(:grupos, [
      Grupo.create!(
        :nome => "Nome",
        :descricao => "MyText"
      ),
      Grupo.create!(
        :nome => "Nome",
        :descricao => "MyText"
      )
    ])
  end

  it "renders a list of grupos" do
    render
    assert_select "tr>td", :text => "Nome".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
