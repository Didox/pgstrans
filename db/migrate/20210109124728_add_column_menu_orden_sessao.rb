class AddColumnMenuOrdenSessao < ActiveRecord::Migration[5.2]
  def change
    rename_column :menus, :ordem, :ordem_sessao
    add_column :menus, :ordem_item, :integer
  end
end