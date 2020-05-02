class AcessosPerfilUsuario < ActiveRecord::Migration[5.2]
  def change
  	add_column :perfil_usuarios, :acessos, :text
  	remove_column :master_profiles, :acessos, :text
  end
end
