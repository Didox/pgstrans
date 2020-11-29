require 'rails_helper'

RSpec.describe "movicel_loops/show", type: :view do
  before(:each) do
    @movicel_loop = assign(:movicel_loop, MovicelLoop.create!(
      :usuario => "Usuario",
      :token => "Token",
      :uri => "Uri",
      :ambiente => "Ambiente",
      :agente => "Agente",
      :terminal => "Terminal",
      :valor => 2.5,
      :repeticao => 3,
      :nropedidoinicio => "9.99",
      :nropedido => "9.99",
      :request => "Request",
      :response => "Response"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Usuario/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/Uri/)
    expect(rendered).to match(/Ambiente/)
    expect(rendered).to match(/Agente/)
    expect(rendered).to match(/Terminal/)
    expect(rendered).to match(/2.5/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Request/)
    expect(rendered).to match(/Response/)
  end
end
