class ChangeTableProdutoFieldMoedaToReference < ActiveRecord::Migration[5.2]
  def change
  	remove_column :produtos, :moeda
 	add_reference :produtos, :moeda, foreign_key: true
  end
end
