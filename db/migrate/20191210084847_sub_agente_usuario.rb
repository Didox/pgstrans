class SubAgenteUsuario < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :sub_agente, foreign_key: true
  	add_column :usuarios, :seller_id_parceiro, :bigint
  	remove_column :usuarios, :agent_id_parceiro
  end
end
