class CreateAlegacaoDePagamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :alegacao_de_pagamentos do |t|
      t.references :usuario, foreign_key: true
      t.float :valor_deposito
      t.datetime :data_deposito
      t.string :numero_talao
      t.references :banco, foreign_key: true
      t.string :comprovativo

      t.timestamps
    end
  end
end
