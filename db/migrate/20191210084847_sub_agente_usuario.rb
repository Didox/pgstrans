class SubAgenteUsuario < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :sub_agente, foreign_key: true
  	add_column :sub_agentes, :seller_id_parceiro, :bigint
  end
end
