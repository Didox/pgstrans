class SubAgentesFields < ActiveRecord::Migration[5.2]
  def change
  	remove_column :sub_agentes, :industry_id
  	remove_column :sub_agentes, :provincia
    add_reference :sub_agentes, :provincia, foreign_key: true
    add_reference :sub_agentes, :industry, foreign_key: true
  end
end
