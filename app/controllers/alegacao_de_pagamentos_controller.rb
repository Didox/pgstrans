class AlegacaoDePagamentosController < ApplicationController
  before_action :set_alegacao_de_pagamento, only: [:show, :edit, :update, :destroy]
  before_action :upload_arquivo, only: [:create, :update]

  # GET /alegacao_de_pagamentos
  # GET /alegacao_de_pagamentos.json
  def index
    @alegacao_de_pagamentos = AlegacaoDePagamento.com_acesso(usuario_logado).order(id: :asc)  

    options = {page: params[:page] || 1, per_page: 10}
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.paginate(options)   

  end

  # GET /alegacao_de_pagamentos/1
  # GET /alegacao_de_pagamentos/1.json
  def show
  end

  # GET /alegacao_de_pagamentos/new
  def new
    @alegacao_de_pagamento = AlegacaoDePagamento.new
  end

  # GET /alegacao_de_pagamentos/1/edit
  def edit
  end

  # POST /alegacao_de_pagamentos
  # POST /alegacao_de_pagamentos.json
  def create
    @alegacao_de_pagamento = AlegacaoDePagamento.new(alegacao_de_pagamento_params)
    @alegacao_de_pagamento.responsavel = usuario_logado

    respond_to do |format|
      if @alegacao_de_pagamento.save
        format.html { redirect_to @alegacao_de_pagamento, notice: 'Alegação de pagamento foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @alegacao_de_pagamento }
      else
        format.html { render :new }
        format.json { render json: @alegacao_de_pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alegacao_de_pagamentos/1
  # PATCH/PUT /alegacao_de_pagamentos/1.json
  def update
    respond_to do |format|
      if @alegacao_de_pagamento.update(alegacao_de_pagamento_params)
        format.html { redirect_to @alegacao_de_pagamento, notice: 'Alegação de pagamento foi atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @alegacao_de_pagamento }
      else
        format.html { render :edit }
        format.json { render json: @alegacao_de_pagamento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alegacao_de_pagamentos/1
  # DELETE /alegacao_de_pagamentos/1.json
  def destroy
    @alegacao_de_pagamento.destroy
    respond_to do |format|
      format.html { redirect_to alegacao_de_pagamentos_url, notice: 'Alegação de pagamento foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def upload_arquivo
      return if params[:alegacao_de_pagamento].blank? || params[:alegacao_de_pagamento][:comprovativo].is_a?(String)
      comprovativo = params[:alegacao_de_pagamento][:comprovativo]
      if comprovativo.present?
        params[:alegacao_de_pagamento][:comprovativo] = AwsService.upload(comprovativo.tempfile.path, comprovativo.original_filename)
      else
        params[:alegacao_de_pagamento].delete(:comprovativo)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_alegacao_de_pagamento
      @alegacao_de_pagamento = AlegacaoDePagamento.find(params[:id])
      @alegacao_de_pagamento.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alegacao_de_pagamento_params
      params.require(:alegacao_de_pagamento).permit(:usuario_id, :valor_deposito, :data_deposito, :numero_talao, :banco_id, :comprovativo)
    end
end
