require 'rails_helper'

RSpec.describe "status_bancos/show", type: :view do
  before(:each) do
    @status_banco = assign(:status_banco, StatusBanco.create!(
      :nome => "Nome"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
  end
end
