class RemuneracaosController < ApplicationController
  before_action :set_remuneracao, only: [:show, :edit, :update, :destroy]

  # GET /remuneracaos
  # GET /remuneracaos.json
  def index
    @remuneracaos = Remuneracao.all.order(usuario_id: :asc)
    @remuneracaos = @remuneracaos.joins("inner join usuarios on usuarios.id = remuneracaos.usuario_id")
    @remuneracaos = @remuneracaos.where("lower(usuarios.nome) ilike ? ", "%#{params[:nome]}%") if params[:nome].present?
    @remuneracaos = @remuneracaos.where("lower(usuarios.email) ilike ? ", "%#{params[:email]}%") if params[:email].present?

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
    # Use callbacks to share common setup or constraints between actions.
    def set_remuneracao
      @remuneracao = Remuneracao.find(params[:id])
      @remuneracao.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remuneracao_params
      params.require(:remuneracao).permit(:usuario_id, :vigencia_inicio, :vigencia_fim)
    end
end
