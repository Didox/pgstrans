class RemuneracaosController < ApplicationController
  before_action :set_remuneracao, only: [:show, :edit, :update, :destroy]
  before_action :usuarios_distribuidor, only: [:edit, :new]
  
  # GET /remuneracaos
  # GET /remuneracaos.json
  def index
    @remuneracaos = Remuneracao.com_acesso(usuario_logado).order(usuario_id: :asc)
    @remuneracaos = @remuneracaos.joins("inner join usuarios on usuarios.id = remuneracaos.usuario_id")
    @remuneracaos = @remuneracaos.where("lower(usuarios.nome) ilike ? ", "%#{params[:nome]}%") if params[:nome].present?
    @remuneracaos = @remuneracaos.where("lower(usuarios.email) ilike ? ", "%#{params[:email]}%") if params[:email].present?
    @remuneracaos = @remuneracaos.where("lower(usuarios.login) ilike ? ", "%#{params[:login]}%") if params[:login].present?
    @remuneracaos = @remuneracaos.where("ativo = ?", params[:ativo]) if params[:ativo].present?
    @remuneracaos = @remuneracaos.where("remuneracaos.vigencia_inicio >= ?", SqlDate.sql_parse(params[:vigencia_inicio_de].to_datetime.beginning_of_day)) if params[:vigencia_inicio_de].present?
    @remuneracaos = @remuneracaos.where("remuneracaos.vigencia_inicio <= ?", SqlDate.sql_parse(params[:vigencia_inicio_ate].to_datetime.end_of_day)) if params[:vigencia_inicio_ate].present?
    @remuneracaos = @remuneracaos.where("usuarios.sub_distribuidor_id = ?", params[:sub_distribuidor_id]) if params[:sub_distribuidor_id].present?
    @remuneracaos = @remuneracaos.where("usuarios.sub_agente_id = ?", params[:sub_agente_id]) if params[:sub_agente_id].present?

    #@remuneracaos = @remuneracaos.joins(:usuario)
    #@remuneracaos = @remuneracaos.reorder("remuneracao.usuario.nome asc")
    #@remuneracaos = @remuneracaos.where("remuneracao.usuario.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @remuneracaos_total = @remuneracaos.count

    options = {page: params[:page] || 1, per_page: 10}
    @remuneracaos = @remuneracaos.paginate(options)
  end

  # GET /remuneracaos/1
  # GET /remuneracaos/1.json
  def show
  end

  # GET /remuneracaos/new
  def new
    @remuneracao = Remuneracao.new
  end

  # GET /remuneracaos/1/edit
  def edit
  end

  # POST /remuneracaos
  # POST /remuneracaos.json
  def create
    @remuneracao = Remuneracao.new(remuneracao_params)
    @remuneracao.responsavel = usuario_logado
    
    respond_to do |format|
      if @remuneracao.save
        salvar_remuneracao_desconto
        format.html { redirect_to @remuneracao, notice: 'Remuneração foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @remuneracao }
      else
        format.html { render :new }
        format.json { render json: @remuneracao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /remuneracaos/1
  # PATCH/PUT /remuneracaos/1.json
  def update
    respond_to do |format|
      if @remuneracao.update(remuneracao_params)
        salvar_remuneracao_desconto
        format.html { redirect_to @remuneracao, notice: 'Remuneração foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @remuneracao }
      else
        format.html { render :edit }
        format.json { render json: @remuneracao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remuneracaos/1
  # DELETE /remuneracaos/1.json
  def destroy
    @remuneracao.destroy
    respond_to do |format|
      format.html { redirect_to remuneracaos_url, notice: 'Remuneração foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def salvar_remuneracao_desconto
      RemuneracaoDesconto.where(remuneracao_id: @remuneracao.id).destroy_all
      if params[:partner_descontos].present?
        params[:partner_descontos].each do |partner_desconto|
          RemuneracaoDesconto.create(
            partner_id: partner_desconto["id"],
            remuneracao_id: @remuneracao.id,
            desconto_parceiro_id: params["parceiro_desconto_id_partner_id_#{partner_desconto["id"]}"]
          )
        end
      end
    end
    
    def set_remuneracao
      @remuneracao = Remuneracao.find(params[:id])
      @remuneracao.responsavel = usuario_logado
    end

    def usuarios_distribuidor
      @usuarios = Usuario.com_acesso(usuario_logado)
      if !usuario_logado.admin? && !usuario_logado.operador?
        @usuarios = @usuarios.where("usuarios.id not in (?) and sub_distribuidor_id = ?", usuario_logado.id, usuario_logado.sub_distribuidor_id)
      end
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def remuneracao_params
      params.require(:remuneracao).permit(:usuario_id, :ativo, :vigencia_inicio, :vigencia_fim)
    end
end
