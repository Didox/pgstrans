class RemoveCamposProdutosValorMinimoVenda < ActiveRecord::Migration[5.2]
  def change
  	remove_column :produtos, :valor_minimo_venda_telemovel
	remove_column :produtos, :valor_minimo_venda_site  	
	remove_column :produtos, :valor_minimo_venda_pos
	remove_column :produtos, :valor_minimo_venda_tef 	
  end
end
