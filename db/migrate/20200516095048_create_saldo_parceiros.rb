class CreateSaldoParceiros < ActiveRecord::Migration[5.2]
  def change
    create_table :saldo_parceiros do |t|
      t.references :partner, foreign_key: true
      t.float :saldo
      t.text :log

      t.timestamps
    end
  end
end
