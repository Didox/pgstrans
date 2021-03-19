require 'rails_helper'

RSpec.describe "status_bancos/index", type: :view do
  before(:each) do
    assign(:status_bancos, [
      StatusBanco.create!(
        :nome => "Nome"
      ),
      StatusBanco.create!(
        :nome => "Nome"
      )
    ])
  end

  it "renders a list of status_bancos" do
    render
    assert_select "tr>td", :text => "Nome".to_s, :count => 2
  end
end
