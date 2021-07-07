class AlegacaoDePagamentosController < ApplicationController
  before_action :set_alegacao_de_pagamento, only: [:show, :edit, :update, :destroy, :processar]
  before_action :upload_arquivo, only: [:create, :update]
  before_action :valida_acesso, only: [:edit, :update, :destroy, :processar]

  # GET /alegacao_de_pagamentos
  # GET /alegacao_de_pagamentos.json
  def index
    @alegacao_de_pagamentos = AlegacaoDePagamento.com_acesso(usuario_logado).order(created_at: :desc)
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.joins("inner join usuarios on usuarios.id = alegacao_de_pagamentos.usuario_id")
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("alegacao_de_pagamentos.data_deposito >= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_inicio].to_datetime.beginning_of_day)) if params[:data_alegacao_pagamento_inicio].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("alegacao_de_pagamentos.data_deposito <= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_fim].to_datetime.end_of_day)) if params[:data_alegacao_pagamento_fim].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("alegacao_de_pagamentos.updated_at >= ?", SqlDate.sql_parse(params[:updated_at_inicio].to_datetime.beginning_of_day)) if params[:updated_at_inicio].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("alegacao_de_pagamentos.updated_at <= ?", SqlDate.sql_parse(params[:updated_at_fim].to_datetime.end_of_day)) if params[:updated_at_fim].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("usuarios.id = ?", params[:id]) if params[:id].present?
    @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("usuarios.perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
    
    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      @alegacao_de_pagamentos  = @alegacao_de_pagamentos.where("usuarios.status_cliente_id = ?", params[:status])
    end

    params[:status_alegacao_de_pagamento_id] = (StatusAlegacaoDePagamento.where("lower(nome) = 'pendente'").first.id rescue "") unless params.has_key?(:status_alegacao_de_pagamento_id)
    if params[:status_alegacao_de_pagamento_id].present?
      @alegacao_de_pagamentos = @alegacao_de_pagamentos.where("alegacao_de_pagamentos.status_alegacao_de_pagamento_id = ?", params[:status_alegacao_de_pagamento_id]) if params[:status_alegacao_de_pagamento_id].present?
    end

    @valor_total  = @alegacao_de_pagamentos.sum(:valor_deposito)
    @qtd_total  = @alegacao_de_pagamentos.count
    
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
    return redirect_to "/alegacao_de_pagamentos" if [StatusAlegacaoDePagamento::PROCESSADO,StatusAlegacaoDePagamento::CANCELADO,StatusAlegacaoDePagamento::INVALIDO,StatusAlegacaoDePagamento::REJEITADO].include?(@alegacao_de_pagamento.status_alegacao_de_pagamento.nome) 
  end

  # POST /alegacao_de_pagamentos
  # POST /alegacao_de_pagamentos.json
  def create
    @alegacao_de_pagamento = AlegacaoDePagamento.new(alegacao_de_pagamento_params)
    @alegacao_de_pagamento.responsavel = usuario_logado
    @alegacao_de_pagamento.comprovativo = "https://st2.depositphotos.com/6544740/9337/i/600/depositphotos_93376372-stock-photo-sunset-over-sea-pier.jpg"

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
    return redirect_to "/alegacao_de_pagamentos" if [StatusAlegacaoDePagamento::PROCESSADO,StatusAlegacaoDePagamento::CANCELADO,StatusAlegacaoDePagamento::INVALIDO,StatusAlegacaoDePagamento::REJEITADO].include?(@alegacao_de_pagamento.status_alegacao_de_pagamento.nome) 

    respond_to do |format|
      if @alegacao_de_pagamento.update(alegacao_de_pagamento_params_update)
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
    return redirect_to "/alegacao_de_pagamentos" if [StatusAlegacaoDePagamento::PROCESSADO,StatusAlegacaoDePagamento::CANCELADO,StatusAlegacaoDePagamento::INVALIDO,StatusAlegacaoDePagamento::REJEITADO].include?(@alegacao_de_pagamento.status_alegacao_de_pagamento.nome) 
    
    @alegacao_de_pagamento.destroy
    respond_to do |format|
      format.html { redirect_to alegacao_de_pagamentos_url, notice: 'Alegação de pagamento foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  def processar
    return redirect_to "/alegacao_de_pagamentos" if [StatusAlegacaoDePagamento::PROCESSADO,StatusAlegacaoDePagamento::CANCELADO,StatusAlegacaoDePagamento::INVALIDO,StatusAlegacaoDePagamento::REJEITADO].include?(@alegacao_de_pagamento.status_alegacao_de_pagamento.nome) 
    
    @alegacao_de_pagamento.processar(usuario_logado)
    respond_to do |format|
      format.html { redirect_to alegacao_de_pagamentos_url, notice: 'Alegação de pagamento foi processada com sucesso.' }
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

    
    def set_alegacao_de_pagamento
      @alegacao_de_pagamento = AlegacaoDePagamento.find(params[:id] || params[:alegacao_de_pagamento_id])
      @alegacao_de_pagamento.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alegacao_de_pagamento_params
      params[:alegacao_de_pagamento].delete(:observacao) unless (@adm.admin? || @adm.operador?)
      params.require(:alegacao_de_pagamento).permit(:usuario_id, :valor_deposito, :status_alegacao_de_pagamento_id, :observacao, :data_deposito, :numero_talao, :banco_id, :comprovativo)
    end

    def alegacao_de_pagamento_params_update
      params.require(:alegacao_de_pagamento).permit(:valor_deposito, :status_alegacao_de_pagamento_id, :observacao, :data_deposito, :numero_talao, :banco_id, :comprovativo)
    end

    def valida_acesso
      if @alegacao_de_pagamento.status_alegacao_de_pagamento.nome == StatusAlegacaoDePagamento::PROCESSADO || (!@adm.admin? && !@adm.operador?)
        flash[:error] = "Sem permissão para realizar esta operação"
        redirect_to alegacao_de_pagamentos_url
      end
    end
end
