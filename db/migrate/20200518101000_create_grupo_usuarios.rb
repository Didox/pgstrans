class CreateGrupoUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :grupo_usuarios do |t|
      t.references :usuario, foreign_key: true
      t.references :grupo, foreign_key: true

      t.timestamps
    end
  end
end
