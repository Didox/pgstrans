class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs do |t|
      t.string :titulo
      t.string :responsavel
      t.text :dados_alterados

      t.timestamps
    end
  end
end
