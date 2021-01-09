class OrderMenu < ActiveRecord::Migration[5.2]
  def change
    add_column :menus, :ordem, :integer
  end
end
