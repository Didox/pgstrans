class CreateMoedas < ActiveRecord::Migration[5.2]
  def change
    create_table :moedas do |t|
      t.string :nome
      t.string :codigo_iso
      t.string :simbolo
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
