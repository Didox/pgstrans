class AgentePerfil < ActiveRecord::Migration[5.2]
  def change
    add_column :perfil_usuarios, :agente, :boolean
  end
end
