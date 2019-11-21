class CreateProvincia < ActiveRecord::Migration[5.2]
  def change
    create_table :provincia do |t|
      t.string :nome
      t.string :capital
      t.string :area_km2
      t.integer :population
      t.string :image_map
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
