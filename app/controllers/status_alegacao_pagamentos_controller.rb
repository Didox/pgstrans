class StatusAlegacaoPagamentosController < ApplicationController
  before_action :set_status_alegacao_pagamento, only: [:show, :edit, :update, :destroy]

  # GET /status_alegacao_pagamentos
  # GET /status_alegacao_pagamentos.json
  def index
    @status_alegacao_pagamentos = StatusAlegacaoPagamento.all.order(nome: :asc)
  end

  # GET /status_alegacao_pagamentos/1
  # GET /status_alegacao_pagamentos/1.json
  def show
  end

  # GET /status_alegacao_pagamentos/new
  def new
    @status_alegacao_pagamento = StatusAlegacaoPagamento.new
  end

  # GET /status_alegacao_pagamentos/1/edit
  def edit
  end

  # POST /status_alegacao_pagamentos
  # POST /status_alegacao_pagamentos.json
  def create
    @status_alegacao_pagamento = StatusAlegacaoPagamento.new(status_alegacao_pagamento_params)

    respond_to do |format|
      if @status_alegacao_pagamento.save
        format.html { redirect_to @status_alegacao_pagamento, notice: 'Status alegacao pagamento was successfully created.' }
        format.json { render :show, status: :created, location: @status_alegacao_pagamento }
      else
        format.html { render :new }
        format.json { render json: @status_alegacao_pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /status_alegacao_pagamentos/1
  # PATCH/PUT /status_alegacao_pagamentos/1.json
  def update
    respond_to do |format|
      if @status_alegacao_pagamento.update(status_alegacao_pagamento_params)
        format.html { redirect_to @status_alegacao_pagamento, notice: 'Status alegacao pagamento was successfully updated.' }
        format.json { render :show, status: :ok, location: @status_alegacao_pagamento }
      else
        format.html { render :edit }
        format.json { render json: @status_alegacao_pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /status_alegacao_pagamentos/1
  # DELETE /status_alegacao_pagamentos/1.json
  def destroy
    @status_alegacao_pagamento.destroy
    respond_to do |format|
      format.html { redirect_to status_alegacao_pagamentos_url, notice: 'Status alegacao pagamento was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_alegacao_pagamento
      @status_alegacao_pagamento = StatusAlegacaoPagamento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def status_alegacao_pagamento_params
      params.require(:status_alegacao_pagamento).permit(:nome)
    end
end
