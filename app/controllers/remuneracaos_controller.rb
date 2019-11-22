class RemuneracaosController < ApplicationController
  before_action :set_remuneracao, only: [:show, :edit, :update, :destroy]

  # GET /remuneracaos
  # GET /remuneracaos.json
  def index
    @remuneracaos = Remuneracao.all.order(usuario_id: :asc)
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

    respond_to do |format|
      if @remuneracao.save
        format.html { redirect_to @remuneracao, notice: 'Remuneracao foi criado com sucesso.' }
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
        format.html { redirect_to @remuneracao, notice: 'Remuneracao foi atualizado com sucesso.' }
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
      format.html { redirect_to remuneracaos_url, notice: 'Remuneracao foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_remuneracao
      @remuneracao = Remuneracao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def remuneracao_params
      params.require(:remuneracao).permit(:usuario_id, :produto_id, :valor_venda_final_telemovel, :valor_venda_final_site, :valor_venda_final_pos, :valor_venda_final_tef, :vigencia_inicio, :vigencia_fim)
    end
end
