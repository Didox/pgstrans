class UsuarioLogsTransacao < ActiveRecord::Migration[5.2]
  def change
    remove_column :pagamentos_faturas_dstvs, :administrador_id
    add_column :pagamentos_faturas_dstvs, :usuario_id, :bigint
    remove_column :alteracoes_planos_dstvs, :administrador_id
    add_column :alteracoes_planos_dstvs, :usuario_id, :bigint
  end
end
