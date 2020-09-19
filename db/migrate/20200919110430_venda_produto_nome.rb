class VendaProdutoNome < ActiveRecord::Migration[5.2]
  def change
    add_column :vendas, :product_nome, :string
  end
end
