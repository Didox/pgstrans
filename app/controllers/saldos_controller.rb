class SaldosController < ApplicationController
  def index
  	if usuario_logado.admin?
      @conta_correntes = ContaCorrente.all
      @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
      @conta_correntes = @conta_correntes.reorder("updated_at desc")
      @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", params[:data_alegacao_pagamento].to_datetime.beginning_of_day) if params[:data_alegacao_pagamento].present?
      @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo <= ?", params[:data_ultima_atualizacao_saldo].to_date.end_of_day) if params[:data_ultima_atualizacao_saldo].present?
      @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    else
      @conta_correntes = ContaCorrente.where(usuario: usuario_logado)
    end

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end
end
