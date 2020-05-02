class CanalVendasController < ApplicationController
  before_action :set_canal_venda, only: [:show, :edit, :update, :destroy]

  # GET /canal_vendas
  # GET /canal_vendas.json
  def index
    @canal_vendas = CanalVenda.all.order(nome: :asc)
  end

  # GET /canal_vendas/1
  # GET /canal_vendas/1.json
  def show
  end

  # GET /canal_vendas/new
  def new
    @canal_venda = CanalVenda.new
  end

  # GET /canal_vendas/1/edit
  def edit
  end

  # POST /canal_vendas
  # POST /canal_vendas.json
  def create
    @canal_venda = CanalVenda.new(canal_venda_params)

    respond_to do |format|
      if @canal_venda.save
        format.html { redirect_to @canal_venda, notice: 'Canal de venda foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @canal_venda }
      else
        format.html { render :new }
        format.json { render json: @canal_venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /canal_vendas/1
  # PATCH/PUT /canal_vendas/1.json
  def update
    respond_to do |format|
      if @canal_venda.update(canal_venda_params)
        format.html { redirect_to @canal_venda, notice: 'Canal de venda foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @canal_venda }
      else
        format.html { render :edit }
        format.json { render json: @canal_venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /canal_vendas/1
  # DELETE /canal_vendas/1.json
  def destroy
    @canal_venda.destroy
    respond_to do |format|
      format.html { redirect_to canal_vendas_url, notice: 'Canal de venda foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_canal_venda
      @canal_venda = CanalVenda.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def canal_venda_params
      params.require(:canal_venda).permit(:nome, :carregamento_minimo, :dispositivo_id)
    end
end
