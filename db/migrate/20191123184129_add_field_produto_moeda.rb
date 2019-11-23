class AddFieldProdutoMoeda < ActiveRecord::Migration[5.2]
  def change
  	add_column :produtos, :moeda, :string
  end
end
