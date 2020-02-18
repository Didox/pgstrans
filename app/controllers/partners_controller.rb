class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy]

  # GET /partners
  # GET /partners.json
  def index
    @partners = Partner.all.order(id: :asc)
  end

  # GET /partners/1
  # GET /partners/1.json
  def show
    @relatorio_conciliacao_zaptvs = RelatorioConciliacaoZaptv.where(partner: @partner)

    if request.path_parameters[:format] == 'csv'
      relatorio_conciliacao_zaptvs = []
      @relatorio_conciliacao_zaptvs.each do |conciliacao|
        relatorio_conciliacao_zaptvs << {
          "Operation code" => conciliacao.operation_code,
          "Source reference" => conciliacao.source_reference,
          "Product code" => conciliacao.product_code,
          "Quantity" => conciliacao.quantity,
          "Date" => conciliacao.date_time.strftime("%d/%m/%Y %H:%M:%S"),
          "Type" => conciliacao.type_data,
          "Total price" => conciliacao.total_price,
          "Status" => conciliacao.status,
          "Unit price" => conciliacao.unit_price
        }
      end
      filename = "relatorio_conciliacao_zaptvs-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
      send_data(relatorio_conciliacao_zaptvs.to_csv, :type => "text/csv; charset=utf-8; header=present", :filename => filename)
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
      @partner = Partner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partner_params
      params.require(:partner).permit(:name, :slug, :status_parceiro_id, :order)
    end
end
