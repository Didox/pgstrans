class SmsHistoricoEnviosController < ApplicationController
  before_action :set_sms_historico_envio, only: %i[ show edit update destroy ]

  # GET /sms_historico_envios or /sms_historico_envios.json
  def index
    @sms_historico_envios = SmsHistoricoEnvio.all
  end

  # GET /sms_historico_envios/1 or /sms_historico_envios/1.json
  def show
  end

  # GET /sms_historico_envios/new
  def new
    @sms_historico_envio = SmsHistoricoEnvio.new
  end

  # GET /sms_historico_envios/1/edit
  def edit
  end

  # POST /sms_historico_envios or /sms_historico_envios.json
  def create
    @sms_historico_envio = SmsHistoricoEnvio.new(sms_historico_envio_params)

    respond_to do |format|
      if @sms_historico_envio.save
        format.html { redirect_to sms_historico_envio_url(@sms_historico_envio), notice: "Sms historico envio was successfully created." }
        format.json { render :show, status: :created, location: @sms_historico_envio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sms_historico_envio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sms_historico_envios/1 or /sms_historico_envios/1.json
  def update
    respond_to do |format|
      if @sms_historico_envio.update(sms_historico_envio_params)
        format.html { redirect_to sms_historico_envio_url(@sms_historico_envio), notice: "Sms historico envio was successfully updated." }
        format.json { render :show, status: :ok, location: @sms_historico_envio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sms_historico_envio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sms_historico_envios/1 or /sms_historico_envios/1.json
  def destroy
    @sms_historico_envio.destroy

    respond_to do |format|
      format.html { redirect_to sms_historico_envios_url, notice: "Sms historico envio was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sms_historico_envio
      @sms_historico_envio = SmsHistoricoEnvio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sms_historico_envio_params
      params.require(:sms_historico_envio).permit(:numero, :conteudo, :usuario_id, :venda_id, :sucesso)
    end
end
