require 'rails_helper'

RSpec.describe "logs/edit", type: :view do
  before(:each) do
    @log = assign(:log, Log.create!(
      :titulo => "MyString",
      :responsavel => "MyString",
      :dados_alterados => "MyText"
    ))
  end

  it "renders the edit log form" do
    render

    assert_select "form[action=?][method=?]", log_path(@log), "post" do

      assert_select "input[name=?]", "log[titulo]"

      assert_select "input[name=?]", "log[responsavel]"

      assert_select "textarea[name=?]", "log[dados_alterados]"
    end
  end
end
