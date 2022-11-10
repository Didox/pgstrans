json.extract! conta_corrente, :usuario_id, :valor, :iban, :data_alegacao_pagamento, :saldo_anterior, :saldo_atual, :data_ultima_atualizacao_saldo
json.lancamento_nome conta_corrente.lancamento.nome
json.banco_nome conta_corrente.banco.nome