class ProdutoProdutoIdParceiroString < ActiveRecord::Migration[5.2]
  def change
  	change_column :produtos, :produto_id_parceiro, :string
  end
end
