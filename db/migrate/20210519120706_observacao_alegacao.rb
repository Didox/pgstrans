class ObservacaoAlegacao < ActiveRecord::Migration[5.2]
  def change
    add_column :alegacao_de_pagamentos, :observacao, :text
  end
end
