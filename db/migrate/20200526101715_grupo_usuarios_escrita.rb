class GrupoUsuariosEscrita < ActiveRecord::Migration[5.2]
  def change
    add_column :grupo_usuarios, :escrita, :boolean, default: false
  end
end
