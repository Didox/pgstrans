class UsuarioReferenciaPagamentosController < ApplicationController
  def index
    @usuario_referencia_pagamentos = UsuarioReferenciaPagamento.all.order(created_at: :desc)

    options = {page: params[:page] || 1, per_page: 10}
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.paginate(options)

    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.joins(:usuario)
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("CAST(usuario_referencia_pagamentos.nro_pagamento_referencia AS VARCHAR) ilike '%#{params[:nro_pagamento_referencia].remove_injection}%'") if params[:nro_pagamento_referencia].present?
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("acao = ?", params[:acao]) if params[:acao].present?
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("usuario_referencia_pagamentos.created_at >= ?", SqlDate.sql_parse(params[:data_ocorrencia_inicio].to_datetime)) if params[:data_ocorrencia_inicio].present?
    @usuario_referencia_pagamentos = @usuario_referencia_pagamentos.where("usuario_referencia_pagamentos.created_at <= ?", SqlDate.sql_parse(params[:data_ocorrencia_fim].to_datetime)) if params[:data_ocorrencia_fim].present?

  end
end
