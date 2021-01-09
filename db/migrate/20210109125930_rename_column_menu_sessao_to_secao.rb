class RenameColumnMenuSessaoToSecao < ActiveRecord::Migration[5.2]
  def change
    rename_column :menus, :sessao, :secao
    rename_column :menus, :ordem_sessao, :ordem_secao
  end
end
