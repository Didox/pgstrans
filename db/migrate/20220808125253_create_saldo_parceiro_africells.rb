class CreateSaldoParceiroAfricells < ActiveRecord::Migration[5.2]
  def change
    create_table :saldo_parceiro_africells do |t|
      t.float :dealer_balance
      t.text :request

      t.timestamps
    end
  end
end
