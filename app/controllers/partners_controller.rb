class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy, :atualiza_saldo, :importa_produtos, :importa_dados]

  # GET /partners
  # GET /partners.json
  def index
    #@partners = Partner.all.order(id: :asc)
    @partners = Partner.com_acesso(usuario_logado).order(id: :asc)

    options = {page: params[:page] || 1, per_page: 10}
    @partners = @partners.paginate(options)    
  end

  def importa_dados
    partner = Partner.where(slug: "ZAPTv").first
    partner.importa_dados!

    flash[:notice] = 'Dados importados com sucesso.'
    redirect_to partner_url(partner)
  end

  def importa_produtos
    partner = Partner.where(slug: "ZAPTv").first
    partner.importa_produtos!

    flash[:notice] = 'Produtos importados com sucesso.'
    redirect_to partner_url(partner)
  end

  def atualiza_saldo
    @partner.atualiza_saldo!

    flash[:notice] = 'Saldo atualizado com sucesso.'
    redirect_to partner_url(@partner)
  end
  

  # GET /partners/1
  # GET /partners/1.json
  def show
    @relatorio_conciliacao_zaptvs = RelatorioConciliacaoZaptv.where(partner: @partner)

    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time >= ?", params[:data_inicio].to_datetime.beginning_of_day) if params[:data_inicio].present?
    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.where("relatorio_conciliacao_zaptvs.date_time <= ?", params[:data_fim].to_datetime.end_of_day) if params[:data_fim].present?
    @relatorio_conciliacao_zaptvs = @relatorio_conciliacao_zaptvs.reorder("date_time desc")

    if params[:csv].present?
      filename = "relatorio_conciliacao_zaptvs-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
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
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id] || params[:partner_id])
      @partner.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partner_params
      params.require(:partner).permit(:name, :slug, :status_parceiro_id, :order)
    end
end
