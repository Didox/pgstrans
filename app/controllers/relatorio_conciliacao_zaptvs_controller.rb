class RelatorioConciliacaoZaptvsController < ApplicationController
  before_action :set_relatorio_conciliacao_zaptv, only: [:show, :edit, :update, :destroy]

  # GET /relatorio_conciliacao_zaptvs
  # GET /relatorio_conciliacao_zaptvs.json
  def index
    @relatorio_conciliacao_zaptvs = RelatorioConciliacaoZaptv.all
  end

  # GET /relatorio_conciliacao_zaptvs/1
  # GET /relatorio_conciliacao_zaptvs/1.json
  def show
  end

  # GET /relatorio_conciliacao_zaptvs/new
  def new
    @relatorio_conciliacao_zaptv = RelatorioConciliacaoZaptv.new
  end

  # GET /relatorio_conciliacao_zaptvs/1/edit
  def edit
  end

  # POST /relatorio_conciliacao_zaptvs
  # POST /relatorio_conciliacao_zaptvs.json
  def create
    @relatorio_conciliacao_zaptv = RelatorioConciliacaoZaptv.new(relatorio_conciliacao_zaptv_params)

    respond_to do |format|
      if @relatorio_conciliacao_zaptv.save
        format.html { redirect_to @relatorio_conciliacao_zaptv, notice: 'Relatorio conciliacao zaptv was successfully created.' }
        format.json { render :show, status: :created, location: @relatorio_conciliacao_zaptv }
      else
        format.html { render :new }
        format.json { render json: @relatorio_conciliacao_zaptv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relatorio_conciliacao_zaptvs/1
  # PATCH/PUT /relatorio_conciliacao_zaptvs/1.json
  def update
    respond_to do |format|
      if @relatorio_conciliacao_zaptv.update(relatorio_conciliacao_zaptv_params)
        format.html { redirect_to @relatorio_conciliacao_zaptv, notice: 'Relatorio conciliacao zaptv was successfully updated.' }
        format.json { render :show, status: :ok, location: @relatorio_conciliacao_zaptv }
      else
        format.html { render :edit }
        format.json { render json: @relatorio_conciliacao_zaptv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relatorio_conciliacao_zaptvs/1
  # DELETE /relatorio_conciliacao_zaptvs/1.json
  def destroy
    @relatorio_conciliacao_zaptv.destroy
    respond_to do |format|
      format.html { redirect_to relatorio_conciliacao_zaptvs_url, notice: 'Relatorio conciliacao zaptv was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relatorio_conciliacao_zaptv
      @relatorio_conciliacao_zaptv = RelatorioConciliacaoZaptv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def relatorio_conciliacao_zaptv_params
      params.require(:relatorio_conciliacao_zaptv).permit(:partner_id, :url, :operation_code, :source_reference, :product_code, :quantity, :date_time, :type_data, :total_price, :status, :unit_price)
    end
end
