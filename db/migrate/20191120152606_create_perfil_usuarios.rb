class CreatePerfilUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :perfil_usuarios do |t|
      t.string :nome
      t.boolean :admin

      t.timestamps
    end
  end
end
