class SaldosController < ApplicationController
  def index
    @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("data_alegacao_pagamento desc")
    
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", params[:data_alegacao_pagamento_inicio].to_datetime.beginning_of_day) if params[:data_alegacao_pagamento_inicio].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento <= ?", params[:data_alegacao_pagamento_fim].to_datetime.end_of_day) if params[:data_alegacao_pagamento_fim].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end
end
