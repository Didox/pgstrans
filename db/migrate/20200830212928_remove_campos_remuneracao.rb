class RemoveCamposRemuneracao < ActiveRecord::Migration[5.2]
  def change
  	remove_column :remuneracaos, :valor_venda_final_telemovel
  	remove_column :remuneracaos, :valor_venda_final_site
  	remove_column :remuneracaos, :valor_venda_final_pos
  	remove_column :remuneracaos, :valor_venda_final_tef
  end
end
