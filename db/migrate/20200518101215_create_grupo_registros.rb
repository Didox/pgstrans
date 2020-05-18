class CreateGrupoRegistros < ActiveRecord::Migration[5.2]
  def change
    create_table :grupo_registros do |t|
      t.string :modelo
      t.bigint :modelo_id
      t.references :grupo, foreign_key: true

      t.timestamps
    end
  end
end
