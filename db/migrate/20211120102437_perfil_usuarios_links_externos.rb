class PerfilUsuariosLinksExternos < ActiveRecord::Migration[5.2]
  def change
    add_column :perfil_usuarios, :links_externos, :text
  end
end
