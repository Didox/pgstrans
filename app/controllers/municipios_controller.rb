class MunicipiosController < ApplicationController
  before_action :set_municipio, only: [:show, :edit, :update, :destroy]
  
  # GET /municipios
  # GET /municipios.json
  def index_api
    index
  end

  def index
    @municipios = Municipio.com_acesso(usuario_logado).order(nome: :asc)  
    
    @municipios = @municipios.where("municipios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
 
    options = {page: params[:page] || 1, per_page: 10}
    @municipios = @municipios.paginate(options)
  end

  # GET /municipios/1
  # GET /municipios/1.json
  def show
  end

  # GET /municipios/new
  def new
    @municipio = Municipio.new
  end

  # GET /municipios/1/edit
  def edit
  end

  # POST /municipios
  # POST /municipios.json
  def create
    @municipio = Municipio.new(municipio_params)
    @municipio.responsavel = usuario_logado

    respond_to do |format|
      if @municipio.save
        format.html { redirect_to @municipio, notice: 'Municipio foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @municipio }
      else
        format.html { render :new }
        format.json { render json: @municipio.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /municipios/1
  # PATCH/PUT /municipios/1.json
  def update
    respond_to do |format|
      if @municipio.update(municipio_params)
        format.html { redirect_to @municipio, notice: 'Municipio foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @municipio }
      else
        format.html { render :edit }
        format.json { render json: @municipio.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipios/1
  # DELETE /municipios/1.json
  def destroy
    @municipio.destroy
    respond_to do |format|
      format.html { redirect_to municipios_url, notice: 'Municipio foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_municipio
      @municipio = Municipio.find(params[:id])
      @municipio.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def municipio_params
      params.require(:municipio).permit(:nome)
    end
end
