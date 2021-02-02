class CreateSaldoParceiroDstvs < ActiveRecord::Migration[5.2]
  def change
    create_table :saldo_parceiro_dstvs do |t|
      t.references :partner, foreign_key: true
      t.text :request
      t.text :response

      t.timestamps
    end
  end
end
