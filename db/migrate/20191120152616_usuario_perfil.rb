class UsuarioPerfil < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :perfil_usuarios, foreign_key: true
  end
end
