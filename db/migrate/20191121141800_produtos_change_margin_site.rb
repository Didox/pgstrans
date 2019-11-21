class ProdutosChangeMarginSite < ActiveRecord::Migration[5.2]
  def change
  	remove_column :produtos, :margem_site
  	add_column :produtos, :margem_site, :float
  end
end
