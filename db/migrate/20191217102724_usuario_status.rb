class UsuarioStatus < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :status_cliente, foreign_key: true
  end
end
