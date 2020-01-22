class ProdutosCode < ActiveRecord::Migration[5.2]
  def change
  	add_column :produtos, :code, :string
  end
end
