class CreateMunicipios < ActiveRecord::Migration[5.2]
  def change
    create_table :municipios do |t|
      t.string :nome

      t.timestamps
    end
  end
end
