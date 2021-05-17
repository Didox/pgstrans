class StatusAlegacaoDePagamentos < ActiveRecord::Migration[5.2]
  def change
  	add_reference :alegacao_de_pagamentos, :status_alegacao_de_pagamento, foreign_key: true
  end
end
