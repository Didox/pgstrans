class SaldosController < ApplicationController
  def index
    return if nao_buscavel
    
    @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("data_alegacao_pagamento desc")
    
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_inicio].to_datetime.beginning_of_day)) if params[:data_alegacao_pagamento_inicio].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento <= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_fim].to_datetime.end_of_day)) if params[:data_alegacao_pagamento_fim].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?
    
    @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @conta_correntes = @conta_correntes.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?

    @valor_total = @conta_correntes.sum(:valor)

    @total_ocorrencias = @conta_correntes.count
    @soma_saldo_anterior = @conta_correntes.sum(:saldo_anterior)
    @soma_valor = @conta_correntes.sum(:valor)
    @soma_saldo_atual = @conta_correntes.sum(:saldo_atual)

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end
end
