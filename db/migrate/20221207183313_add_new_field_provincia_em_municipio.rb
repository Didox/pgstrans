class AddNewFieldProvinciaEmMunicipio < ActiveRecord::Migration[5.2]
  def change
  	add_reference :municipios, :provincia, foreign_key: true

  end
end
