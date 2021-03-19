class IncluirStatusBancos < ActiveRecord::Migration[5.2]
  def change
    add_column :bancos, :status_banco_id, :integer
  end
end
