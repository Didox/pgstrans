class VendasConciliacaoController < ApplicationController

  def index_vendas_conciliacao
    #@vendas = @vendas.joins(:usuario)
    @vendas = Venda.all.order(updated_at: :desc, partner_id: :asc)
    if params[:return_code].nil?
      params[:return_code] = "sucesso"
    end

    if params[:return_code].present?
      if params[:return_code] == "sucesso"
        @vendas = @vendas.where("vendas.status in (?)", ReturnCodeApi.where(sucesso: true).map{|r| r.return_code })
      else
        ret = ReturnCodeApi.find(params[:return_code])
        @vendas = @vendas.where("vendas.status = ? and vendas.partner_id = ?", ret.return_code, ret.partner_id)
      end
    end

    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      @vendas = @vendas.joins("inner join usuarios on usuarios.id = vendas.usuario_id")
      @vendas = @vendas.where("usuarios.status_cliente_id = ?", params[:status])
    end

    @vendas = @vendas.where("vendas.id = ?", params[:venda_id]) if params[:venda_id].present?
    @vendas = @vendas.where("vendas.updated_at >= ?", params[:data_inicio].to_datetime.beginning_of_day) if params[:data_inicio].present?
    @vendas = @vendas.where("vendas.updated_at <= ?", params[:data_fim].to_date.end_of_day) if params[:data_fim].present?
    @vendas = @vendas.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    @vendas = @vendas.where("usuarios.login ilike '%#{params[:login]}%'") if params[:login].present?
    @vendas = @vendas.where("vendas.partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
    @vendas = @vendas.where("vendas.product_id = ?", params[:produto_id]) if params[:produto_id].present?
    @vendas = @vendas.where("vendas.produto_id_parceiro = ?", params[:produto_id_parceiro]) if params[:produto_id_parceiro].present?
    @vendas = @vendas.where("vendas.usuario_id = ?", params[:id_interno]) if params[:id_interno].present?
    
    @vendas = @vendas.joins("inner join partners on partners.id = vendas.partner_id")
    if params[:status_parceiro_id].present?
      @vendas = @vendas.where("partners.status_parceiro_id = ?", params[:status_parceiro_id])
    else
      @vendas = @vendas.where("partners.status_parceiro_id in (?)", StatusParceiro::ATIVO_TEMPORARIAMENTE_INDISPONIVEL)
    end
    
    @vendas = @vendas.where("vendas.agent_id = ?", params[:agente]) if params[:agente].present?
    @vendas = @vendas.where("vendas.store_id = ?", params[:store]) if params[:store].present?
    @vendas = @vendas.where("vendas.seller_id = ?", params[:seller]) if params[:seller].present?
    @vendas = @vendas.where("vendas.value > ?", params[:valor].to_f) if params[:valor].present?
    @vendas = @vendas.where("vendas.client_msisdn = ?", params[:client_msisdn]) if params[:client_msisdn].present?
    @vendas = @vendas.where("vendas.request_id = '#{params[:log]}' or request_send ilike '%#{params[:log]}%' or response_get ilike '%#{params[:log]}%'") if params[:log].present?
      
    if params[:csv].present?
      filename = "relatorio_vendas-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
      send_data(@vendas.to_csv, :type => "text/csv; charset=utf-8; header=present", :filename => filename)
      return
    end
   
    options = {page: params[:page] || 1, per_page: 30}
    @vendas = @vendas.paginate(options)
  end
end
