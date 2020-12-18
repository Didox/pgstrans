class ContaCorrentesController < ApplicationController
  before_action :set_conta_corrente, only: [:show, :edit, :update, :destroy]

  # GET /conta_correntes
  # GET /conta_correntes.json
  def index
    if usuario_logado.admin? || usuario_logado.operador?
      @conta_correntes = ContaCorrente.all
    else
      @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    end

    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("data_alegacao_pagamento desc")
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", params[:data_alegacao_pagamento].to_datetime.beginning_of_day) if params[:data_alegacao_pagamento].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo <= ?", params[:data_ultima_atualizacao_saldo].to_date.end_of_day) if params[:data_ultima_atualizacao_saldo].present?
    @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    @conta_correntes = @conta_correntes.where("usuarios.login ilike '%#{params[:login]}%'") if params[:login].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.observacao ilike '%#{params[:observacao]}%'") if params[:observacao].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.iban ilike '%#{params[:iban]}%'") if params[:iban].present?
    if params[:responsavel].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios as responsavel on responsavel.id = conta_correntes.responsavel_aprovacao_id")
      @conta_correntes = @conta_correntes.where("responsavel.nome ilike '%#{params[:responsavel]}%'")
    end

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end

  # GET /conta_correntes/1
  # GET /conta_correntes/1.json
  def show
  end

  def index_morada_saldo
    @usuarios = Usuario.com_acesso(usuario_logado)
    options = {page: params[:page] || 1, per_page: 10}
    @usuarios = @usuarios.paginate(options)
    @usuarios = @usuarios.reorder("nome asc")
    @usuarios = @usuarios.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
  end

  def index_carregamento_usuario
    @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    @conta_correntes = @conta_correntes.where(usuario_id: params[:usuario_id])

    if params[:nome].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
      @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome]}%'")
    end

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
    @conta_correntes = @conta_correntes.reorder("created_at desc")
  end

  # GET /conta_correntes/new
  def new
    @conta_corrente = ContaCorrente.new
    @conta_corrente.responsavel = usuario_logado
    @conta_corrente.data_alegacao_pagamento = Time.zone.now
  end

  # GET /conta_correntes/1/edit
  def edit
  end

  # POST /conta_correntes
  # POST /conta_correntes.json
  def create
    ActiveRecord::Base.transaction do
      if !usuario_logado.admin? && !usuario_logado.operador? && !usuario_logado.agente?
        flash[:error] = "Somente o Administrador tem acesso a essa operação."
        redirect_to conta_correntes_url
        return
      end

      if !usuario_logado.admin? && !usuario_logado.operador? && (usuario_logado.saldo < 0.1 || usuario_logado.saldo < conta_corrente_params[:valor].to_f)
        flash[:error] = "Saldo insuficiente."
        redirect_to conta_correntes_url
        return
      end
      
      @conta_corrente = ContaCorrente.new(conta_corrente_params)
      @conta_corrente.responsavel = usuario_logado
      @conta_corrente.responsavel_aprovacao_id = usuario_logado.id
      
      if @conta_corrente.lancamento.nome == Lancamento::DEBITO
        @conta_corrente.valor = "-#{@conta_corrente.valor.abs}"
      else
        @conta_corrente.valor = @conta_corrente.valor.abs
      end

      respond_to do |format|
        if @conta_corrente.save

          if !usuario_logado.admin? && !usuario_logado.operador? && @conta_corrente.lancamento.nome != Lancamento::DEBITO
            conta_corrente_retirada = ContaCorrente.new(conta_corrente_params)
            conta_corrente_retirada.id = nil
            conta_corrente_retirada.valor = "-#{conta_corrente_retirada.valor.abs}"
            conta_corrente_retirada.usuario = usuario_logado
            conta_corrente_retirada.responsavel = usuario_logado
            conta_corrente_retirada.lancamento = Lancamento.where(nome: Lancamento::TRANSFERENCIA_ENTRE_USUARIOS).first || Lancamento.first
            conta_corrente_retirada.responsavel_aprovacao_id = usuario_logado.id
            conta_corrente_retirada.observacao = "Transferência entre contas para o usuário #{@conta_corrente.usuario.nome} (#{@conta_corrente.usuario_id}). #{conta_corrente_retirada.observacao}"
            conta_corrente_retirada.save!
          end

          format.html { redirect_to conta_correntes_url, notice: 'Transação efetuada com sucesso.' }
          format.json { render :show, status: :created, location: @conta_corrente }
        else
          format.html { render :new }
          format.json { render json: @conta_corrente.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /conta_correntes/1
  # DELETE /conta_correntes/1.json
  def destroy
    if !usuario_logado.admin? && !usuario_logado.operador? && !usuario_logado.agente?
      flash[:error] = "Somente o Administrador tem acesso a essa operação."
      redirect_to conta_correntes_url
      return
    end

    @conta_corrente.destroy
    respond_to do |format|
      format.html { redirect_to conta_correntes_url, notice: 'Conta corrente foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conta_corrente
      @conta_corrente = ContaCorrente.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conta_corrente_params
      params.require(:conta_corrente).permit(:usuario_id, :lancamento_id, :banco_id, :valor, :iban, :data_alegacao_pagamento, :observacao)
    end
end
