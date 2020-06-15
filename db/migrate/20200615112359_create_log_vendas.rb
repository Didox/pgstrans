class CreateLogVendas < ActiveRecord::Migration[5.2]
  def change
    create_table :log_vendas do |t|
      t.string :titulo
      t.text :log

      t.timestamps
    end
  end
end
