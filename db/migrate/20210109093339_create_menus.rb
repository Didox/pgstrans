class CreateMenus < ActiveRecord::Migration[5.2]
  def change
    create_table :menus do |t|
      t.string :sessao
      t.string :nome
      t.string :link
      t.string :controller
      t.string :action

      t.timestamps
    end
  end
end
