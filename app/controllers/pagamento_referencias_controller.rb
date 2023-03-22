class PagamentoReferenciasController < ApplicationController
  before_action :set_pagamento_referencia, only: %i[ show edit update destroy ]

  # GET /pagamento_referencias or /pagamento_referencias.json
  def index
    @pagamento_referencias = PagamentoReferencia.com_acesso(usuario_logado).order(created_at: :desc)

    options = {page: params[:page] || 1, per_page: 10}
    @pagamento_referencias = @pagamento_referencias.paginate(options)

    @pagamento_referencias = @pagamento_referencias.joins(:usuario)
    @pagamento_referencias = @pagamento_referencias.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @pagamento_referencias = @pagamento_referencias.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @pagamento_referencias = @pagamento_referencias.where("nro_pagamento_referencia ilike '%#{params[:nro_pagamento_referencia].remove_injection}%'") if params[:nro_pagamento_referencia].present?
    @pagamento_referencias = @pagamento_referencias.where("id_trn_parceiro ilike '%#{params[:id_trn_parceiro].remove_injection}%'") if params[:id_trn_parceiro].present?
    @pagamento_referencias = @pagamento_referencias.where("valor_pagamento ilike '%#{params[:valor_pagamento].remove_injection}%'") if params[:valor_pagamento].present?
    @pagamento_referencias = @pagamento_referencias.where("valor_pagamento ilike '%#{params[:valor_pagamento].remove_injection}%'") if params[:valor_pagamento].present?
    @pagamento_referencias = @pagamento_referencias.where("data_pagamento >= ?", SqlDate.sql_parse(params[:data_pagamento].to_datetime.beginning_of_day)) if params[:data_pagamento].present?
    @pagamento_referencias = @pagamento_referencias.where("data_conciliacao >= ?", SqlDate.sql_parse(params[:data_conciliacao].to_datetime.beginning_of_day)) if params[:data_conciliacao].present?
    @pagamento_referencias = @pagamento_referencias.where("terminal_type ilike '%#{params[:terminal_type].remove_injection}%'") if params[:terminal_type].present?
  end

  # GET /pagamento_referencias/1 or /pagamento_referencias/1.json
  def show
  end

  # GET /pagamento_referencias/new
  def new
    @pagamento_referencia = PagamentoReferencia.new
  end

  # GET /pagamento_referencias/1/edit
  def edit
  end

  # POST /pagamento_referencias or /pagamento_referencias.json
  def create

    @pagamento_referencia = PagamentoReferencia.new(pagamento_referencia_params)
    @pagamento_referencia.responsavel = usuario_logado

    respond_to do |format|
      if @pagamento_referencia.save
        format.html { redirect_to pagamento_referencia_url(@pagamento_referencia), notice: "Pagamento referência criado com sucesso." }
        format.json { render :show, status: :created, location: @pagamento_referencia }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pagamento_referencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagamento_referencias/1 or /pagamento_referencias/1.json
  def update
    @pagamento_referencia.update(pagamento_referencia_params)

    respond_to do |format|
      if @pagamento_referencia.update(pagamento_referencia_params)
        format.html { redirect_to pagamento_referencia_url(@pagamento_referencia), notice: "Pagamento referência alterado com sucesso." }
        format.json { render :show, status: :ok, location: @pagamento_referencia }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pagamento_referencia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagamento_referencias/1 or /pagamento_referencias/1.json
  def destroy
    @pagamento_referencia.destroy

    respond_to do |format|
      format.html { redirect_to pagamento_referencias_url, notice: "Pagamento referência apagado com sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagamento_referencia
      @pagamento_referencia = PagamentoReferencia.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pagamento_referencia_params
      params.require(:pagamento_referencia).permit(:usuario_id, :nro_pagamento_referencia, :id_trn_parceiro, :valor_pagamento, :data_pagamento, :data_conciliacao, :terminal_id, :terminal_location, :terminal_type)
    end
end
