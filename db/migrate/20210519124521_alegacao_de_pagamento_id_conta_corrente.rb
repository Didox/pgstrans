class AlegacaoDePagamentoIdContaCorrente < ActiveRecord::Migration[5.2]
  def change
  	add_reference :conta_correntes, :alegacao_de_pagamento, foreign_key: true
  end
end
