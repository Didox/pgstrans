require 'rails_helper'

RSpec.describe "grupos/show", type: :view do
  before(:each) do
    @grupo = assign(:grupo, Grupo.create!(
      :nome => "Nome",
      :descricao => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/MyText/)
  end
end
