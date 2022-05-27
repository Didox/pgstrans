class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy, :atualiza_saldo, :importa_produtos, :importa_dados, :zap_conciliacao]
  before_action :upload_arquivo, only: [:create, :update]

  # GET /partners
  # GET /partners.json
  def index
    @partners = Partner.com_acesso(usuario_logado).order(id: :asc)

    @partners = @partners.where(id: params[:parceiro_id]) if params[:parceiro_id].present?
    @partners = @partners.where(status_parceiro_id: params[:status_parceiro_id]) if params[:status_parceiro_id].present?
    
    options = {page: params[:page] || 1, per_page: 10}
    @partners = @partners.paginate(options)    
  end

  def importa_dados
    partner = Partner.find(params[:partner_id])
    partner.importa_dados!(params[:categoria])

    flash[:notice] = 'Dados importados com sucesso.'
    redirect_to partner_url(partner)
  end

  def importa_produtos
    partner = Partner.find(params[:partner_id])
    partner.importa_produtos!(params[:categoria])

    flash[:notice] = 'Produtos importados com sucesso.'
    redirect_to partner_url(partner)
  end

  def atualiza_saldo
    @partner.atualiza_saldo!(request.ip)

    flash[:notice] = 'Saldo atualizado com sucesso.'
    redirect_to partner_url(@partner)
  rescue Exception => erro
    flash[:error] = "Problemas na atualização de saldo - #{erro.message}"
    redirect_to partner_url(@partner)
  end
  

  # GET /partners/1
  # GET /partners/1.json

  def self.show(partner, params)
    @relatorio_conciliacao_zaptvs = RelatorioConciliacaoZaptv.where(partner: partner)

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("lower(relatorio_conciliacao_zaptvs.categoria) >= ?", params[:categoria].to_s.downcase) if params[:categoria].present?

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)) if params[:data_inicio].present?

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)) if params[:data_fim].present?

    if params[:operation_code].present?
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.joins("inner join vendas on vendas.partner_id = relatorio_conciliacao_zaptvs.partner_id")
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("vendas.response_get ilike '%:#{params[:operation_code]},%' or vendas.response_get ilike '%: #{params[:operation_code]},%'")
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where(operation_code: params[:operation_code])
    end

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.reorder("date_time desc")
  end

  def show;end

  def zap_conciliacao
    #if (params[:data_inicio].blank? || params[:data_fim].blank?) || params[:data_inicio].to_datetime < (DateTime.now - 91.days)
    @relatorio_conciliacao_zaptvs = []
    if !params.has_key?(:data_inicio) || !params.has_key?(:data_fim) || params[:data_inicio].blank? || params[:data_fim].blank?
      flash[:error] = 'Selecione o período para agendar o relatório de conciliação'
    else
      if params[:csv].present?
        Relatorio.create(partner_id: @partner.id, usuario_id: usuario_logado.id, parametros: params.to_json, categoria: params[:categoria]).envia_sqs
        flash[:notice] = 'Agendamento do processamento do relatório realizado com sucesso.'
      end

      if params.keys.length > 3
        @relatorio_conciliacao_zaptvs = PartnersController.show(@partner, params)
  
        options = {page: params[:page] || 1, per_page: 10}
        @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.paginate(options)
      end
    end
  end


  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit
  end

  # POST /partners
  # POST /partners.json
  def create
    @partner = Partner.new(partner_params)
    @partner.responsavel = usuario_logado

    respond_to do |format|
      if @partner.save
        format.html { redirect_to @partner, notice: 'Partner foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @partner }
      else
        format.html { render :new }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partners/1
  # PATCH/PUT /partners/1.json
  def update
    respond_to do |format|
      if @partner.update(partner_params)
        format.html { redirect_to @partner, notice: 'Partner foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @partner }
      else
        format.html { render :edit }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner.destroy
    respond_to do |format|
      format.html { redirect_to partners_url, notice: 'Partner foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def upload_arquivo
      return if params[:partner].blank? || params[:partner][:imagem].is_a?(String)
      imagem = params[:partner][:imagem]
      if imagem.present?
        params[:partner][:imagem] = AwsService.upload(imagem.tempfile.path, imagem.original_filename)
      else
        params[:partner].delete(:imagem)
      end
    end
    
    def set_partner
      @partner = Partner.find(params[:id] || params[:partner_id])
      @partner.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partner_params
      params.require(:partner).permit(:name, :desconto, :imagem, :slug, :status_parceiro_id, :order)
    end
end
