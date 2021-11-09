class UsuarioDistribuidor < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :sub_distribuidor, foreign_key: true, default: 8
  end
end
