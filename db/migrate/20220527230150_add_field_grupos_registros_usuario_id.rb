class AddFieldGruposRegistrosUsuarioId < ActiveRecord::Migration[5.2]
  def change
    add_column :grupo_registros, :usuario_id, :bigint
  end
end
