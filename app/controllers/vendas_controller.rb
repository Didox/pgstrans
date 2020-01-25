class VendasController < ApplicationController
  before_action :set_venda, only: [:show, :edit, :update, :destroy, :mostrar_resumido]

  # GET /vendas
  # GET /vendas.json
  def index
    vendas_busca
  end

  # GET /vendas/1
  # GET /vendas/1.json
  def show
  end

  def mostrar_resumido
  end

  def reverter_venda_zaptv
    @venda = Venda.find(params[:venda_id])
    retorno = @venda.reverter_venda_zaptv
    if retorno == "sucesso"
      flash[:success] = "Venda revertida com sucesso"
    else
      flash[:error] = "Venda não revertida - #{retorno}"
    end
    
    redirect_to @venda 
  end

  # GET /vendas/new
  def new
    @venda = Venda.new
  end

  # GET /vendas/1/edit
  def edit
  end

  def resumido
    vendas_busca
    @vendas = @vendas.where(usuario_id: usuario_logado.id)
  end

  # POST /vendas
  # POST /vendas.json
  def create
    @venda = Venda.new(venda_params)

    respond_to do |format|
      if @venda.save
        format.html { redirect_to @venda, notice: 'Venda foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @venda }
      else
        format.html { render :new }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendas/1
  # PATCH/PUT /vendas/1.json
  def update
    respond_to do |format|
      if @venda.update(venda_params)
        format.html { redirect_to @venda, notice: 'Venda foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @venda }
      else
        format.html { render :edit }
        format.json { render json: @venda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendas/1
  # DELETE /vendas/1.json
  def destroy
    @venda.destroy
    respond_to do |format|
      format.html { redirect_to vendas_url, notice: 'Venda foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def vendas_busca
      @vendas = Venda.all.reorder("updated_at desc")
      @vendas = @vendas.joins(:usuario)
      @vendas = @vendas.where("vendas.status = ?", params[:return_code]) if params[:return_code].present?
      @vendas = @vendas.where("vendas.updated_at >= ?", params[:data_inicio].to_datetime.beginning_of_day) if params[:data_inicio].present?
      @vendas = @vendas.where("vendas.updated_at <= ?", params[:data_fim].to_date.end_of_day) if params[:data_fim].present?
      @vendas = @vendas.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
      @vendas = @vendas.where("vendas.partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
      @vendas = @vendas.where("vendas.product_id = ?", params[:produto_id]) if params[:produto_id].present?
      @vendas = @vendas.where("vendas.agent_id = ?", params[:agente]) if params[:agente].present?
      @vendas = @vendas.where("vendas.store_id = ?", params[:store]) if params[:store].present?
      @vendas = @vendas.where("vendas.seller_id = ?", params[:seller]) if params[:seller].present?
      @vendas = @vendas.where("vendas.value = ?", params[:valor]) if params[:valor].present?
      @vendas = @vendas.where("vendas.client_msisdn = ?", params[:client_msisdn]) if params[:client_msisdn].present?
      @vendas = @vendas.where("vendas.request_id = '#{params[:log]}' or request_send ilike '%#{params[:log]}%' or response_get ilike '%#{params[:log]}%'") if params[:log].present?

      options = {page: params[:page] || 1, per_page: 10}
      @vendas = @vendas.paginate(options)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_venda
      @venda = Venda.find(params[:id] || params[:venda_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venda_params
      params.require(:venda).permit(:product_id, :agent_id, :store_id, :seller_id, :terminal_id, :value, :client_msisdn, :request_send, :response_get)
    end
end
