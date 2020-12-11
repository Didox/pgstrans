class VendasController < ApplicationController
  before_action :set_venda, only: [:show, :edit, :update, :destroy, :mostrar_resumido]

  # GET /vendas
  # GET /vendas.json
  def index
    @vendas = Venda.com_acesso(usuario_logado).order(id: :asc)
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
      flash[:success] = "Venda revertida com sucesso."
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
    @vendas = Venda.where(usuario_id: usuario_logado.id)
    vendas_busca
  end

  # POST /vendas
  # POST /vendas.json
  def create
    @venda = Venda.new(venda_params)
    @venda.responsavel = usuario_logado

    respond_to do |format|
      if @venda.save
        format.html { redirect_to @venda, notice: 'Venda foi criada com sucesso.' }
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
        format.html { redirect_to @venda, notice: 'Venda foi atualizada com sucesso.' }
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
      format.html { redirect_to vendas_url, notice: 'Venda foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def vendas_busca
      @vendas = @vendas.joins(:usuario)

      if params[:return_code].nil?
        params[:return_code] = "sucesso"
      end

      if params[:return_code].present?
        if params[:return_code] == "sucesso"
          @vendas = @vendas.where("vendas.status in (?)", ReturnCodeApi.where(sucesso: true).map{|r| r.return_code })
        else
          ret = ReturnCodeApi.find(params[:return_code])
          @vendas = @vendas.where("vendas.status = ? and vendas.partner_id = ?", ret.return_code, ret.partner_id)
        end
      end

      @vendas = @vendas.where("vendas.id = ?", params[:venda_id]) if params[:venda_id].present?
      @vendas = @vendas.where("vendas.updated_at >= ?", params[:data_inicio].to_datetime.beginning_of_day) if params[:data_inicio].present?
      @vendas = @vendas.where("vendas.updated_at <= ?", params[:data_fim].to_date.end_of_day) if params[:data_fim].present?
      @vendas = @vendas.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
      @vendas = @vendas.where("vendas.partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
      @vendas = @vendas.where("vendas.product_id = ?", params[:produto_id]) if params[:produto_id].present?
      @vendas = @vendas.where("vendas.produto_id_parceiro = ?", params[:produto_id_parceiro]) if params[:produto_id_parceiro].present?
      @vendas = @vendas.where("vendas.agent_id = ?", params[:agente]) if params[:agente].present?
      @vendas = @vendas.where("vendas.store_id = ?", params[:store]) if params[:store].present?
      @vendas = @vendas.where("vendas.seller_id = ?", params[:seller]) if params[:seller].present?
      @vendas = @vendas.where("vendas.value > ?", params[:valor].to_f) if params[:valor].present?
      @vendas = @vendas.where("vendas.client_msisdn = ?", params[:client_msisdn]) if params[:client_msisdn].present?
      @vendas = @vendas.where("vendas.request_id = '#{params[:log]}' or request_send ilike '%#{params[:log]}%' or response_get ilike '%#{params[:log]}%'") if params[:log].present?

      @vendas_graficos = @vendas.clone

      if params[:csv].present?
        filename = "relatorio_vendas-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"
        send_data(@vendas.to_csv, :type => "text/csv; charset=utf-8; header=present", :filename => filename)
        return
      end
      
      options = {page: params[:page] || 1, per_page: 10}
      @vendas = @vendas.paginate(options)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_venda
      @venda = Venda.find(params[:id] || params[:venda_id])
      @venda.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def venda_params
      params.require(:venda).permit(
        :product_id, 
        :produto_id_parceiro,
        :product_nome,
        :agent_id,
        :store_id, 
        :seller_id,
        :terminal_id,
        :valor_original, 
        :desconto_aplicado,
        :value,
        :client_msisdn, 
        :status,
        :status_movicel, 
      )
    end
end