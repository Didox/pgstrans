class ParametrosController < ApplicationController
  before_action :set_parametro, only: [:show, :edit, :update, :destroy]

  # GET /parametros
  # GET /parametros.json
  def index
    @parametros = Parametro.all
  end

  # GET /parametros/1
  # GET /parametros/1.json
  def show
  end

  # GET /parametros/new
  def new
    @parametro = Parametro.new
  end

  # GET /parametros/1/edit
  def edit
  end

  # POST /parametros
  # POST /parametros.json
  def create
    @parametro = Parametro.new(parametro_params)

    respond_to do |format|
      if @parametro.save
        format.html { redirect_to @parametro, notice: 'Parametro was successfully created.' }
        format.json { render :show, status: :created, location: @parametro }
      else
        format.html { render :new }
        format.json { render json: @parametro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parametros/1
  # PATCH/PUT /parametros/1.json
  def update
    respond_to do |format|
      if @parametro.update(parametro_params)
        format.html { redirect_to @parametro, notice: 'Parametro was successfully updated.' }
        format.json { render :show, status: :ok, location: @parametro }
      else
        format.html { render :edit }
        format.json { render json: @parametro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parametros/1
  # DELETE /parametros/1.json
  def destroy
    @parametro.destroy
    respond_to do |format|
      format.html { redirect_to parametros_url, notice: 'Parametro was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parametro
      @parametro = Parametro.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def parametro_params
      params.require(:parametro).permit(:url_integracao_desenvolvimento, :unitel_agente_id, :zaptv_agente_id, :movicel_agente_id, :dstv_agente_id, :url_integracao_producao, :partner_id, :api_key_zaptv_desenvolvimento, :api_key_zaptv_producao, :agent_key_movicel_desenvolvimento, :agent_key_movicel_producao, :user_id_movicel_desenvolvimento, :user_id_movicel_producao, :data_source_dstv_desevolvimento, :data_source_dstv_producao, :payment_vendor_code_dstv_desenvolvimento, :payment_vendor_code_dstv_producao, :vendor_code_dstv_desenvolvimento, :vendor_code_dstv_producao, :agent_account_dstv_desenvolvimento, :agent_account_dstv_producao, :currency_dstv_desenvolvimento, :currency_dstv_producao, :product_user_key_dstv_desenvolvimento, :product_user_key_dstv_producao, :mop_dstv_desenvolvimento, :mop_dstv_producao, :agent_number_dstv_desenvolvimento, :agent_number_dstv_producao)
    end
end
