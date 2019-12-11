json.extract! conta_corrente, :id, :usuario_id, :lancamento_id, :banco_id, :valor, :iban, :data_alegacao_pagamento, :saldo_anterior, :saldo_atual, :data_ultima_atualizacao_saldo, :observacao, :created_at, :updated_at
json.url conta_corrente_url(conta_corrente, format: :json)
