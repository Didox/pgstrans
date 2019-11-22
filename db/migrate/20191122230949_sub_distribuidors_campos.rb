class SubDistribuidorsCampos < ActiveRecord::Migration[5.2]
  def change
  	remove_column :sub_distribuidors, :municipio
  	remove_column :sub_distribuidors, :provincia
    add_reference :sub_distribuidors, :provincia, foreign_key: true
    add_reference :sub_distribuidors, :municipio, foreign_key: true
  end
end
