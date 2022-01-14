class EmailHistoricoEnviosController < ApplicationController
  before_action :set_email_historico_envio, only: %i[ show edit update destroy ]

  # GET /email_historico_envios or /email_historico_envios.json
  def index
    @email_historico_envios = EmailHistoricoEnvio.all
  end

  # GET /email_historico_envios/1 or /email_historico_envios/1.json
  def show
  end

  # GET /email_historico_envios/new
  def new
    @email_historico_envio = EmailHistoricoEnvio.new
  end

  # GET /email_historico_envios/1/edit
  def edit
  end

  # POST /email_historico_envios or /email_historico_envios.json
  def create
    @email_historico_envio = EmailHistoricoEnvio.new(email_historico_envio_params)

    respond_to do |format|
      if @email_historico_envio.save
        format.html { redirect_to email_historico_envio_url(@email_historico_envio), notice: "Email historico envio was successfully created." }
        format.json { render :show, status: :created, location: @email_historico_envio }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @email_historico_envio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_historico_envios/1 or /email_historico_envios/1.json
  def update
    respond_to do |format|
      if @email_historico_envio.update(email_historico_envio_params)
        format.html { redirect_to email_historico_envio_url(@email_historico_envio), notice: "Email historico envio was successfully updated." }
        format.json { render :show, status: :ok, location: @email_historico_envio }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @email_historico_envio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_historico_envios/1 or /email_historico_envios/1.json
  def destroy
    @email_historico_envio.destroy

    respond_to do |format|
      format.html { redirect_to email_historico_envios_url, notice: "Email historico envio was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_historico_envio
      @email_historico_envio = EmailHistoricoEnvio.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_historico_envio_params
      params.require(:email_historico_envio).permit(:email, :titulo, :conteudo, :usuario_id, :venda_id, :sucesso)
    end
end
