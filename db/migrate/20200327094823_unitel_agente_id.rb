class UnitelAgenteId < ActiveRecord::Migration[5.2]
  def change
  	add_column :parametros, :unitel_agente_id, :string
  	add_column :parametros, :zaptv_agente_id, :string
  	add_column :parametros, :movicel_agente_id, :string
  	add_column :parametros, :dstv_agente_id, :string
  end
end
