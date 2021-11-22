class ProvinciaController < ApplicationController
  before_action :set_provincium, only: [:show, :edit, :update, :destroy]

  # GET /provincia
  # GET /provincia.json
  def index_api
    index
  end

  def index
    @provincia = Provincium.com_acesso(usuario_logado).order(nome: :asc)

    @provincia = @provincia.where("nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @provincia = @provincia.where("capital ilike '%#{params[:capital].remove_injection}%'") if params[:capital].present?
    @provincia = @provincia.where("area_km2 ilike '%#{params[:area_km2].remove_injection}%'") if params[:area_km2].present?
    @provincia = @provincia.where("population = ?", params[:population]) if params[:population].present?
   
    options = {page: params[:page] || 1, per_page: 10}
    @provincium = @provincia.paginate(options)
  end

  # GET /provincia/1
  # GET /provincia/1.json
  def show
  end

  # GET /provincia/new
  def new
    @provincium = Provincium.new
  end

  # GET /provincia/1/edit
  def edit
  end

  # POST /provincia
  # POST /provincia.json
  def create
    @provincium = Provincium.new(provincium_params)
    @provincium.responsavel = usuario_logado

    respond_to do |format|
      if @provincium.save
        format.html { redirect_to @provincium, notice: 'Província foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @provincium }
      else
        format.html { render :new }
        format.json { render json: @provincium.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provincia/1
  # PATCH/PUT /provincia/1.json
  def update
    respond_to do |format|
      if @provincium.update(provincium_params)
        format.html { redirect_to @provincium, notice: 'Província foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @provincium }
      else
        format.html { render :edit }
        format.json { render json: @provincium.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provincia/1
  # DELETE /provincia/1.json
  def destroy
    @provincium.destroy
    respond_to do |format|
      format.html { redirect_to provincia_url, notice: 'Província foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_provincium
      @provincium = Provincium.find(params[:id])
      @provincium.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provincium_params
      params.require(:provincium).permit(:nome, :capital, :area_km2, :population, :image_map, :country_id, :nome_pt)
    end
end
