class LogVendasUsuario < ActiveRecord::Migration[5.2]
  def change
    add_column :log_vendas, :usuario_id, :bigint
  end
end
