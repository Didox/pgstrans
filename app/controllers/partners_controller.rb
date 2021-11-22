class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy, :atualiza_saldo, :importa_produtos, :importa_dados]
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
    partner = Partner.zaptv
    partner.importa_dados!

    flash[:notice] = 'Dados importados com sucesso.'
    redirect_to partner_url(partner)
  end

  def importa_produtos
    partner = Partner.find(params[:partner_id])
    partner.importa_produtos!

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
  def show
    @relatorio_conciliacao_zaptvs = RelatorioConciliacaoZaptv.where(partner: @partner)

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)) if params[:data_inicio].present?
    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)) if params[:data_fim].present?

    if params[:operation_code].present?
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.joins("inner join vendas on vendas.partner_id = relatorio_conciliacao_zaptvs.partner_id")
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("vendas.response_get ilike '%:#{params[:operation_code]},%' or vendas.response_get ilike '%: #{params[:operation_code]},%'")
      @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where(operation_code: params[:operation_code])
    end

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.reorder("date_time desc")

    if params[:csv].present?
      filename = "relatorio_conciliacao_zaptvs-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
      send_data(@relatorio_conciliacao_zaptvs.to_csv, :type => "text/csv; charset=utf-8; header=present", :filename => filename)
      return
    end


    options = {page: params[:page] || 1, per_page: 10}
    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.paginate(options)
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
