class CreateStatusAlegacaoDePagamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :status_alegacao_de_pagamentos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
