class UsuarioPerfil < ActiveRecord::Migration[5.2]
  def change
  	add_reference :usuarios, :perfil_usuario, foreign_key: true
  end
end
