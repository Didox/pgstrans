require 'rails_helper'

RSpec.describe "logs/new", type: :view do
  before(:each) do
    assign(:log, Log.new(
      :titulo => "MyString",
      :responsavel => "MyString",
      :dados_alterados => "MyText"
    ))
  end

  it "renders new log form" do
    render

    assert_select "form[action=?][method=?]", logs_path, "post" do

      assert_select "input[name=?]", "log[titulo]"

      assert_select "input[name=?]", "log[responsavel]"

      assert_select "textarea[name=?]", "log[dados_alterados]"
    end
  end
end
