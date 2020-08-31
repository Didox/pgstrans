class RemovendoCamposSemNecessidade < ActiveRecord::Migration[5.2]
  def change
    remove_column :produtos, :margem_telemovel
    remove_column :produtos, :margem_pos
    remove_column :produtos, :margem_site
    remove_column :produtos, :margem_tef
  end
end
