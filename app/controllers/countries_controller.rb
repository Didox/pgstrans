class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  # GET /countries
  # GET /countries.json
  def index
    @countries = Country.com_acesso(usuario_logado).order(name_eng: :asc)

    @countries = @countries.where("name_eng ilike '%#{params[:name_eng].remove_injection}%'") if params[:name_eng].present?
    @countries = @countries.where("name_pt ilike '%#{params[:name_pt].remove_injection}%'") if params[:name_pt].present?
    @countries = @countries.where("iso2 ilike '%#{params[:iso2].remove_injection}%'") if params[:iso2].present?
    @countries = @countries.where("bacen = ?", params[:bacen]) if params[:bacen].present?

    options = {page: params[:page] || 1, per_page: 10}
    @countries = @countries.paginate(options)
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
  end

  # GET /countries/new
  def new
    @country = Country.new
  end

  # GET /countries/1/edit
  def edit
  end

  # POST /countries
  # POST /countries.json
  def create
    @country = Country.new(country_params)
    @country.responsavel = usuario_logado

    respond_to do |format|
      if @country.save
        format.html { redirect_to @country, notice: 'País foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @country }
      else
        format.html { render :new }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /countries/1
  # PATCH/PUT /countries/1.json
  def update
    respond_to do |format|
      if @country.update(country_params)
        format.html { redirect_to @country, notice: 'País foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @country }
      else
        format.html { render :edit }
        format.json { render json: @country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.json
  def destroy
    @country.destroy
    respond_to do |format|
      format.html { redirect_to countries_url, notice: 'País foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_country
      @country = Country.find(params[:id])
      @country.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:name_eng, :name_pt, :iso2, :bacen)
    end
end
