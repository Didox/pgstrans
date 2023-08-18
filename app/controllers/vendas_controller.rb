class VendasController < ApplicationController
  before_action :set_venda, only: [:show, :mini, :recibo, :edit, :update, :destroy, :mostrar_resumido]
  layout "blank", only: [:index_grafico, :index_resumo]


  # GET /vendas
  # GET /vendas.json
  def index
    return if nao_buscavel
    
    @vendas = Venda.com_acesso(usuario_logado)
    vendas_busca
    @vendas_total = @vendas.count
    @vendas
  end

  def consolidado
    return if nao_buscavel

    @vendas = Venda.com_acesso(usuario_logado)
    vendas_busca
    @vendas_total = @vendas.count
  end

  
  def index_resumo
    params["ultimo_dado_consolidado"] = "ok"
    index
  end

  def index_grafico
    index
  end

  def recibo;end

  def show;end
  
  def mini
    render layout: "basico"
  end

  def consolidado
    return if nao_buscavel

    @page = params[:page] || 1
    @page = @page.to_i
    @per_page = params[:per_page]
    @per_page = 31 if params[:per_page].blank?
    @per_page = @per_page.to_i
    fetch = (@page - 1) * @per_page

    sql = "
      SELECT  
        to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD') as data_venda, 
        sum(vendas.valor_original) as valor_original, 
        sum(vendas.desconto_aplicado) as desconto_aplicado, 
        sum(vendas.value) as value
      FROM vendas 
      inner join usuarios on usuarios.id = vendas.usuario_id 
      inner join partners on partners.id = vendas.partner_id 
      WHERE vendas.created_at is not null
    "

    if params[:return_code].present?
      if params[:return_code] == "sucesso"
        status = ReturnCodeApi.where(sucesso: true).map{|r| "'#{r.return_code}'" }.join(",") rescue ""
        sql += " and vendas.status in (#{status})" if status.present?
      else
        ret = ReturnCodeApi.find(params[:return_code])
        sql += " and vendas.status = '#{ret.return_code}' and vendas.partner_id = #{ret.partner_id}"
      end
    end

    if params[:status].present?
      sql += " and usuarios.status_cliente_id = #{params[:status].to_i}"
    end

    sql += " and vendas.updated_at >= '#{SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)}'" if params[:data_inicio].present?
    sql += " and vendas.updated_at <= '#{SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)}'" if params[:data_fim].present?
    sql += " and vendas.partner_id = #{params[:parceiro_id]}" if params[:parceiro_id].present?
    sql += " and vendas.lancamento_id = #{params[:lancamento_id]}" if params[:lancamento_id].present?

    if params[:status_parceiro_id].present?
      sql += " and partners.status_parceiro_id = #{params[:status_parceiro_id].to_i}"
    else
      sql += " and partners.status_parceiro_id in (#{StatusParceiro::ATIVO_TEMPORARIAMENTE_INDISPONIVEL.join(",")})"
    end

    com_acesso_query = Venda.com_acesso_query(@adm)
    sql += "and #{com_acesso_query}" if com_acesso_query.present?

    sql += "
      group by to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD')
      ORDER BY data_venda desc
      limit #{@per_page} offset #{fetch}
    "
    @sql = sql

    @vendas = ActiveRecord::Base.connection.exec_query(sql)

    sql_ano = sql.gsub("to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD')", "to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY')")
    sql_ano = sql_ano.gsub(/\n/, "").gsub(/limit.*/, "")

    if params[:data_inicio].present? && params[:data_fim].present?
      if Time.zone.parse(params[:data_inicio]).month == Time.zone.parse(params[:data_fim]).month
        @grafico_dia = true
        sql_ano = sql.gsub("to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD')", "to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'DD/MM/YYYY')")
      elsif Time.zone.parse(params[:data_inicio]).year == Time.zone.parse(params[:data_fim]).year
        sql_ano = sql.gsub("to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD')", "to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'MM/YYYY')")
      end
    end
    @vendas_data = ActiveRecord::Base.connection.exec_query(sql_ano)

    @vendas_total = @vendas.count
  end

  def mostrar_resumido
  end

  def reverter_venda_zaptv
    @venda = Venda.find(params[:venda_id])
    retorno = @venda.reverter_venda_zaptv
    if retorno == "sucesso"
      flash[:success] = "Venda revertida com sucesso."
    else
      flash[:error] = "Venda não revertida - #{retorno}"
    end
    
    redirect_to @venda 
  end

  # GET /vendas/new
  def new
    @venda = Venda.new
  end

  # GET /vendas/1/edit
  def edit
  end

  def resumido
    @vendas = Venda.where(usuario_id: usuario_logado.id)
    vendas_busca
  end

  # POST /vendas
  # POST /vendas.json
  def create
    @venda = Venda.new(venda_params)
    @venda.responsavel = usuario_logado

    respond_to do |format|
      if @venda.save
        format.html { redirect_to @venda, notice: 'Venda foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @venda }
      else
        format.html { render :new }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendas/1
  # PATCH/PUT /vendas/1.json
  def update
    respond_to do |format|
      if @venda.update(venda_params)
        format.html { redirect_to @venda, notice: 'Venda foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @venda }
      else
        format.html { render :edit }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas/1
  # DELETE /vendas/1.json
  def destroy
    @venda.destroy
    respond_to do |format|
      format.html { redirect_to vendas_url, notice: 'Venda foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def vendas_busca
      @vendas = @vendas.joins(:usuario)

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
      if params[:status].present? || params[:sub_distribuidor_id].present?
        @vendas = @vendas.joins("inner join usuarios on usuarios.id = vendas.usuario_id")
      end

      if params[:status].present?
        @vendas = @vendas.where("usuarios.status_cliente_id = ?", params[:status])
      end

      if params[:sub_distribuidor_id].present?
        @vendas = @vendas.where("usuarios.sub_distribuidor_id = ?", params[:sub_distribuidor_id])
      end

      @vendas = @vendas.where("vendas.id = ?", params[:venda_id]) if params[:venda_id].present?

      @vendas = @vendas.where("vendas.created_at >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime) ) if params[:data_inicio].present?
      @vendas = @vendas.where("vendas.created_at <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime) ) if params[:data_fim].present?
      
      @vendas = @vendas.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
      @vendas = @vendas.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
      @vendas = @vendas.where("vendas.partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
      if params[:slug] == "zaptv"
        @vendas = @vendas.where("vendas.categoria = ?", params[:categoria]) if params[:categoria].present?
      end
      @vendas = @vendas.where("vendas.product_id = ?", params[:produto_id]) if params[:produto_id].present?

      if params[:perfil_usuario_id].present?
        @vendas = @vendas.where("usuarios.perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
      end

      @vendas = @vendas.where("vendas.usuario_id = ?", params[:id_interno]) if params[:id_interno].present?
      @vendas = @vendas.where("vendas.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?

      @vendas = @vendas.joins("inner join partners on partners.id = vendas.partner_id")
      if params[:status_parceiro_id].present?
        @vendas = @vendas.where("partners.status_parceiro_id = ?", params[:status_parceiro_id])
      else
        @vendas = @vendas.where("partners.status_parceiro_id in (?)", StatusParceiro::ATIVO_TEMPORARIAMENTE_INDISPONIVEL)
      end
      
      @vendas = @vendas.where("vendas.value > ?", params[:valor].to_f) if params[:valor].present?
      @vendas = @vendas.where("vendas.customer_number = ?", params[:customer_number].to_s.strip) if params[:customer_number].present?
      @vendas = @vendas.where("vendas.transaction_reference = ?", params[:transaction_reference].to_s.strip) if params[:transaction_reference].present?
      @vendas = @vendas.where("vendas.payment_code = ?", params[:payment_code].to_s.strip) if params[:payment_code].present?
      @vendas = @vendas.where("usuarios.municipio_id = ?", params[:municipio_id].to_s.strip) if params[:municipio_id].present?
      @vendas = @vendas.where("usuarios.provincia_id = ?", params[:provincia_id].to_s.strip) if params[:provincia_id].present?

      @vendas = @vendas.where("vendas.request_id = '#{params[:log]}' or request_send ilike '%#{params[:log].remove_injection}%' or response_get ilike '%#{params[:log].remove_injection}%'") if params[:log].present?
      @vendas = @vendas.reorder("created_at desc")
     
      @vendas_graficos = @vendas.clone

      if params[:csv].present?
        rel = Relatorio.create(controller_acao: "#{params[:controller].camelize}Controller::#{params[:action]}", usuario_id: usuario_logado.id, parametros: params.to_json).envia_sqs

        flash[:success] = "Relatório agendado com sucesso. Aguarde a geração do relatório."
        return redirect_to "/vendas"
      end
     
      if params["relatorio_job"].blank?
        options = {page: params[:page] || 1, per_page: 10}
        @vendas = @vendas.paginate(options)
      end

      @vendas_total = @vendas.count

      if params["ultimo_dado_consolidado"].blank?
        ultimo = ConsolidadoFinanceiro.where(query: @vendas_graficos.to_sql).where('valor_total is not null').order(id: :asc).last
        if ultimo.present?
          ConsolidadoFinanceiro.where(query: @vendas_graficos.to_sql).where("id not in (#{ultimo.id})").destroy_all

          if (Time.zone.now - 1.day) > ultimo.created_at
            ConsolidadoFinanceiro.create(usuario_id: @adm.id, tipo: ConsolidadoFinanceiro::VENDAS, parametros: params.to_json, query: @vendas_graficos.to_sql)
            # mandar para o SQS agendando este total em tempo real, fazer ajax para mostrar total calculado no resumo de vendas
          end
        else
          ConsolidadoFinanceiro.create(usuario_id: @adm.id, tipo: ConsolidadoFinanceiro::VENDAS, parametros: params.to_json, query: @vendas_graficos.to_sql)
          # mandar para o SQS agendando este total em tempo real, fazer ajax para mostrar total calculado no resumo de vendas
        end
      end
    end

    
    def set_venda
      @venda = Venda.find(params[:id] || params[:venda_id])
      @venda.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venda_params
      params.require(:venda).permit(
        :product_id, 
        :produto_id_parceiro,
        :product_nome,
        :agent_id,
        :store_id, 
        :seller_id,
        :terminal_id,
        :valor_original, 
        :desconto_aplicado,
        :value,
        :customer_number, 
        :status,
        :status_movicel, 
      )
    end
end