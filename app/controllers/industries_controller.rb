class IndustriesController < ApplicationController
  before_action :set_industry, only: [:show, :edit, :update, :destroy]

  # GET /industries
  # GET /industries.json
  def index_api
    index
  end

  def index
    @industries = Industry.com_acesso(usuario_logado).order(descricao_seccao: :asc, descricao_divisao: :asc, descricao_grupo: :asc)

    @industries = @industries.where("descricao_seccao ilike '%#{params[:descricao_seccao].remove_injection}%'") if params[:descricao_seccao].present?
    @industries = @industries.where("descricao_divisao ilike '%#{params[:descricao_divisao].remove_injection}%'") if params[:descricao_divisao].present?
    @industries = @industries.where("descricao_grupo ilike '%#{params[:descricao_grupo].remove_injection}%'") if params[:descricao_grupo].present?

    options = {page: params[:page] || 1, per_page: 17}
    @industries = @industries.paginate(options)
  end

  # GET /industries/1
  # GET /industries/1.json
  def show
  end

  # GET /industries/new
  def new
    @industry = Industry.new
  end

  # GET /industries/1/edit
  def edit
  end

  # POST /industries
  # POST /industries.json
  def create
    @industry = Industry.new(industry_params)
    @industry.responsavel = usuario_logado

    respond_to do |format|
      if @industry.save
        format.html { redirect_to @industry, notice: 'ACTIVIDADE ECONÓMICA foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @industry }
      else
        format.html { render :new }
        format.json { render json: @industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /industries/1
  # PATCH/PUT /industries/1.json
  def update
    respond_to do |format|
      if @industry.update(industry_params)
        format.html { redirect_to @industry, notice: 'ACTIVIDADE ECONÓMICA foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @industry }
      else
        format.html { render :edit }
        format.json { render json: @industry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /industries/1
  # DELETE /industries/1.json
  def destroy
    @industry.destroy
    respond_to do |format|
      format.html { redirect_to industries_url, notice: 'ACTIVIDADE ECONÓMICA foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_industry
      @industry = Industry.find(params[:id])
      @industry.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def industry_params
      params.require(:industry).permit(:descricao_seccao, :descricao_divisao, :descricao_grupo)
    end
end
