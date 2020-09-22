class ProdutoIdParceiroMigracao < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :produto_id_parceiro, :string
  end
end
