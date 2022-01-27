class SmsHistoricoEnviosController < ApplicationController
  before_action :set_sms_historico_envio, only: %i[ show edit update destroy ]

  # GET /sms_historico_envios or /sms_historico_envios.json
  def index
    @sms_historico_envios = SmsHistoricoEnvio.all
    
    options = {page: params[:page] || 1, per_page: 10}
    @sms_historico_envios = @sms_historico_envios.paginate(options)
  end

  # GET /sms_historico_envios/1 or /sms_historico_envios/1.json
  def show
  end

  # GET /sms_historico_envios/new
  def new
    @sms_historico_envio = SmsHistoricoEnvio.new
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
