class CreateCanalVendas < ActiveRecord::Migration[5.2]
  def change
    create_table :canal_vendas do |t|
      t.string :nome
      t.float :carragamento_minimo
      t.references :dispositivo, foreign_key: true

      t.timestamps
    end
  end
end
