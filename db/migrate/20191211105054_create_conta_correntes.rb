class CreateContaCorrentes < ActiveRecord::Migration[5.2]
  def change
    create_table :conta_correntes do |t|
      t.references :usuario, foreign_key: true
      t.references :lancamento, foreign_key: true
      t.references :banco, foreign_key: true
      t.float :valor
      t.string :iban
      t.datetime :data_alegacao_pagamento
      t.string :saldo_anterior
      t.string :saldo_atual
      t.datetime :data_ultima_atualizacao_saldo

      t.timestamps
    end
  end
end
