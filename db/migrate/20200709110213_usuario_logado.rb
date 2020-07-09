class UsuarioLogado < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :logado, :boolean
  end
end
