class RenameMatrixFields < ActiveRecord::Migration[5.2]
  def change
  	rename_column :matrix_users, :sub_dist, :sub_distribuidor
  	rename_column :matrix_users, :sub_agent, :sub_agente
  end
end
