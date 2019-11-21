class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name_eng
      t.string :name_pt
      t.string :iso2
      t.integer :bacen

      t.timestamps
    end
  end
end
