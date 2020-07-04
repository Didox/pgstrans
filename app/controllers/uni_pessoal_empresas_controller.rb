class UniPessoalEmpresasController < ApplicationController
  before_action :set_uni_pessoal_empresa, only: [:show, :edit, :update, :destroy]

  # GET /uni_pessoal_empresas
  # GET /uni_pessoal_empresas.json
  def index
    @uni_pessoal_empresas = UniPessoalEmpresa.com_acesso(usuario_logado).order(nome: :asc)

    @uni_pessoal_empresas = @uni_pessoal_empresas.where("nome ilike '%#{params[:nome]}%'") if params[:nome].present?

    options = {page: params[:page] || 1, per_page: 10}
    @uni_pessoal_empresas = @uni_pessoal_empresas.paginate(options) 
  end

  # GET /uni_pessoal_empresas/1
  # GET /uni_pessoal_empresas/1.json
  def show
  end

  # GET /uni_pessoal_empresas/new
  def new
    @uni_pessoal_empresa = UniPessoalEmpresa.new
  end

  # GET /uni_pessoal_empresas/1/edit
  def edit
  end

  # POST /uni_pessoal_empresas
  # POST /uni_pessoal_empresas.json
  def create
    @uni_pessoal_empresa = UniPessoalEmpresa.new(uni_pessoal_empresa_params)
    @uni_pessoal_empresa.responsavel = usuario_logado

    respond_to do |format|
      if @uni_pessoal_empresa.save
        format.html { redirect_to @uni_pessoal_empresa, notice: 'Perfil Unipessoal/Empresa foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @uni_pessoal_empresa }
      else
        format.html { render :new }
        format.json { render json: @uni_pessoal_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uni_pessoal_empresas/1
  # PATCH/PUT /uni_pessoal_empresas/1.json
  def update
    respond_to do |format|
      if @uni_pessoal_empresa.update(uni_pessoal_empresa_params)
        format.html { redirect_to @uni_pessoal_empresa, notice: 'Perfil Unipessoal/Empresa foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @uni_pessoal_empresa }
      else
        format.html { render :edit }
        format.json { render json: @uni_pessoal_empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uni_pessoal_empresas/1
  # DELETE /uni_pessoal_empresas/1.json
  def destroy
    @uni_pessoal_empresa.destroy
    respond_to do |format|
      format.html { redirect_to uni_pessoal_empresas_url, notice: 'Perfil Unipessoal/Empresa foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_uni_pessoal_empresa
      @uni_pessoal_empresa = UniPessoalEmpresa.find(params[:id])
      @uni_pessoal_empresa.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uni_pessoal_empresa_params
      params.require(:uni_pessoal_empresa).permit(:nome)
    end
end
