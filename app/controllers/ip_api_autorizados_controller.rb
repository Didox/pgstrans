class IpApiAutorizadosController < ApplicationController
  before_action :set_ip_api_autorizado, only: %i[ show edit update destroy ]

  # GET /ip_api_autorizados or /ip_api_autorizados.json
  def index
    @ip_api_autorizados = IpApiAutorizado.all

    options = {page: params[:page] || 1, per_page: 10}
    @ip_api_autorizados = @ip_api_autorizados.paginate(options)  
  end

  # GET /ip_api_autorizados/1 or /ip_api_autorizados/1.json
  def show
  end

  # GET /ip_api_autorizados/new
  def new
    @ip_api_autorizado = IpApiAutorizado.new
  end

  # GET /ip_api_autorizados/1/edit
  def edit
  end

  # POST /ip_api_autorizados or /ip_api_autorizados.json
  def create
    @ip_api_autorizado = IpApiAutorizado.new(ip_api_autorizado_params)

    respond_to do |format|
      if @ip_api_autorizado.save
        format.html { redirect_to @ip_api_autorizado, notice: "Ip api autorizado foi criado com sucesso." }
        format.json { render :show, status: :created, location: @ip_api_autorizado }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ip_api_autorizado.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ip_api_autorizados/1 or /ip_api_autorizados/1.json
  def update
    respond_to do |format|
      if @ip_api_autorizado.update(ip_api_autorizado_params)
        format.html { redirect_to @ip_api_autorizado, notice: "Ip api autorizado foi atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @ip_api_autorizado }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ip_api_autorizado.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_api_autorizados/1 or /ip_api_autorizados/1.json
  def destroy
    @ip_api_autorizado.destroy
    respond_to do |format|
      format.html { redirect_to ip_api_autorizados_url, notice: "Ip api autorizado foi apagado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_api_autorizado
      @ip_api_autorizado = IpApiAutorizado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ip_api_autorizado_params
      params.require(:ip_api_autorizado).permit(:ip, :sub_distribuidor_id)
    end
end
