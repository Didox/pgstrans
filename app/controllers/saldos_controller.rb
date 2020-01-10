class SaldosController < ApplicationController
  def index
    @conta_correntes = ContaCorrente.where(usuario: usuario_logado)
    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("updated_at desc")
    
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", params[:data_alegacao_pagamento_inicio].to_datetime.beginning_of_day) if params[:data_alegacao_pagamento_inicio].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento <= ?", params[:data_alegacao_pagamento_fim].to_date.end_of_day) if params[:data_alegacao_pagamento_fim].present?

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end
end
