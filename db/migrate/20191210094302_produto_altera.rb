class ProdutoAltera < ActiveRecord::Migration[5.2]
  def change
  	add_column :produtos, :produto_id_parceiro, :bigint
  	add_column :produtos, :valor_unitario, :float
  	add_column :produtos, :tipo, :string
  	add_column :produtos, :subtipo, :string
  end
end
