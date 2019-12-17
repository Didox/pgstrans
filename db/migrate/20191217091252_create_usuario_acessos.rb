class CreateUsuarioAcessos < ActiveRecord::Migration[5.2]
  def change
    create_table :usuario_acessos do |t|
      t.references :usuario, foreign_key: true
      t.string :mac_adress
      t.timestamps
    end
  end
end
