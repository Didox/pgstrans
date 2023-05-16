class AddFieldProdutoCategoriaVendasConsolidadas < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas_consolidadas, :vendas_product_categoria, :string
  end
end
