class CreateDispositivos < ActiveRecord::Migration[5.2]
  def change
    create_table :dispositivos do |t|
      t.string :nome
      t.string :marca
      t.string :modelo
      t.string :numero_serie
      t.string :macaddr
      t.string :imei

      t.timestamps
    end
  end
end
