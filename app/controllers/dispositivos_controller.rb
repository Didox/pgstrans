class DispositivosController < ApplicationController
  before_action :set_dispositivo, only: [:show, :edit, :update, :destroy]

  # GET /dispositivos
  # GET /dispositivos.json
  def index
    @dispositivos = Dispositivo.com_acesso(usuario_logado).order(nome: :asc)

    options = {page: params[:page] || 1, per_page: 10}
    @dispositivos = @dispositivos.paginate(options)
  end

  # GET /dispositivos/1
  # GET /dispositivos/1.json
  def show
  end

  # GET /dispositivos/new
  def new
    @dispositivo = Dispositivo.new
  end

  # GET /dispositivos/1/edit
  def edit
  end

  # POST /dispositivos
  # POST /dispositivos.json
  def create
    @dispositivo = Dispositivo.new(dispositivo_params)
    @dispositivo.responsavel = usuario_logado

    respond_to do |format|
      if @dispositivo.save
        format.html { redirect_to @dispositivo, notice: 'Dispositivo foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @dispositivo }
      else
        format.html { render :new }
        format.json { render json: @dispositivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dispositivos/1
  # PATCH/PUT /dispositivos/1.json
  def update
    respond_to do |format|
      if @dispositivo.update(dispositivo_params)
        format.html { redirect_to @dispositivo, notice: 'Dispositivo foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @dispositivo }
      else
        format.html { render :edit }
        format.json { render json: @dispositivo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dispositivos/1
  # DELETE /dispositivos/1.json
  def destroy
    @dispositivo.destroy
    respond_to do |format|
      format.html { redirect_to dispositivos_url, notice: 'Dispositivo foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_dispositivo
      @dispositivo = Dispositivo.find(params[:id])
      @dispositivo.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dispositivo_params
      params.require(:dispositivo).permit(:nome, :marca, :modelo, :numero_serie, :macaddr, :imei, :imei2, :rated, :screensize, :so, :ram_rom, :conectividade)
    end
end
