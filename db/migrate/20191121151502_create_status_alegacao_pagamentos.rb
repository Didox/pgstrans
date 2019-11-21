class CreateStatusAlegacaoPagamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :status_alegacao_pagamentos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
