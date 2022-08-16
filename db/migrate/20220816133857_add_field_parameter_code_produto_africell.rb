class AddFieldParameterCodeProdutoAfricell < ActiveRecord::Migration[5.2]
  def change
    add_column :produtos, :parameter_code_africell, :string
  end
end
