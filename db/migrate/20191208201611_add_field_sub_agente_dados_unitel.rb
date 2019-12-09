class AddFieldSubAgenteDadosUnitel < ActiveRecord::Migration[5.2]
  def change
  	add_column :sub_agentes, :store_id_parceiro, :string
  	add_column :sub_agentes, :agent_id_parceiro, :string
  	add_column :sub_agentes, :terminal_id_parceiro, :string
  end
end
