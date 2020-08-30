class NomeComercialProduto < ActiveRecord::Migration[5.2]
  def change
  	add_column :produtos, :nome_comercial, :string
  end
end
