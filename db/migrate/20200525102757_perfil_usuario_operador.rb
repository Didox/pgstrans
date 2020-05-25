class PerfilUsuarioOperador < ActiveRecord::Migration[5.2]
  def change
    add_column :perfil_usuarios, :operador, :boolean, default:false
  end
end
