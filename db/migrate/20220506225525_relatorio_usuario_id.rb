class RelatorioUsuarioId < ActiveRecord::Migration[5.2]
  def change
    add_column :relatorios, :usuario_id, :bigint
  end
end
