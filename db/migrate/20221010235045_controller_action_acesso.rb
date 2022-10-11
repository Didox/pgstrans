class ControllerActionAcesso < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :controller_action, :string
  end
end
