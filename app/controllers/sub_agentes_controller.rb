class SubAgentesController < ApplicationController
  before_action :set_sub_agente, only: [:show, :edit, :update, :destroy]

  # GET /sub_agentes
  # GET /sub_agentes.json
  def index
    @sub_agentes = SubAgente.com_acesso(usuario_logado).order(razao_social: :asc) 

    options = {page: params[:page] || 1, per_page: 10}
    @sub_agentes = @sub_agentes.paginate(options)
  end

  # GET /sub_agentes/1
  # GET /sub_agentes/1.json
  def show
  end

  # GET /sub_agentes/new
  def new
    @sub_agente = SubAgente.new
  end

  # GET /sub_agentes/1/edit
  def edit
  end

  # POST /sub_agentes
  # POST /sub_agentes.json
  def create
    @sub_agente = SubAgente.new(sub_agente_params)
    @sub_agente.responsavel = usuario_logado

    respond_to do |format|
      if @sub_agente.save
        format.html { redirect_to @sub_agente, notice: 'Subagente foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @sub_agente }
      else
        format.html { render :new }
        format.json { render json: @sub_agente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sub_agentes/1
  # PATCH/PUT /sub_agentes/1.json
  def update
    respond_to do |format|
      if @sub_agente.update(sub_agente_params)
        format.html { redirect_to @sub_agente, notice: 'Subagente foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @sub_agente }
      else
        format.html { render :edit }
        format.json { render json: @sub_agente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_agentes/1
  # DELETE /sub_agentes/1.json
  def destroy
    @sub_agente.destroy
    respond_to do |format|
      format.html { redirect_to sub_agentes_url, notice: 'Subagente foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sub_agente
      @sub_agente = SubAgente.find(params[:id])
      @sub_agente.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_agente_params
      params.require(:sub_agente).permit(:razao_social, :nome_fantasia, :bi, :industry_id, :descricao_grupo, :morada, :bairro, :provincia_id, :email, :telefone, :contato, :seller_id_parceiro, :store_id_parceiro, :terminal_id_parceiro, :uni_pessoal_empresas_id)
    end
end
