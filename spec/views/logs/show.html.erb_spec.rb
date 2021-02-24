require 'rails_helper'

RSpec.describe "logs/show", type: :view do
  before(:each) do
    @log = assign(:log, Log.create!(
      :titulo => "Titulo",
      :responsavel => "Responsavel",
      :dados_alterados => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Titulo/)
    expect(rendered).to match(/Responsavel/)
    expect(rendered).to match(/MyText/)
  end
end
