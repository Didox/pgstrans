class RenameDev < ActiveRecord::Migration[5.2]
  def change
  	rename_column :parametros, :user_id_movicel_desevolvimento, :user_id_movicel_desenvolvimento
  	rename_column :parametros, :data_source_dstv_desevolvimento, :data_source_dstv_desenvolvimento
  end
end
