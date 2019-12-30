class ContaCorrentesController < ApplicationController
  before_action :set_conta_corrente, only: [:show, :edit, :update, :destroy]

  # GET /conta_correntes
  # GET /conta_correntes.json
  def index
    if usuario_logado.admin?
      @conta_correntes = ContaCorrente.all
      @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
      @conta_correntes = @conta_correntes.reorder("updated_at desc")
      @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", params[:data_alegacao_pagamento].to_datetime.beginning_of_day) if params[:data_alegacao_pagamento].present?
      @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo <= ?", params[:data_ultima_atualizacao_saldo].to_date.end_of_day) if params[:data_ultima_atualizacao_saldo].present?
      @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    else
      @conta_correntes = ContaCorrente.where(usuario: usuario_logado)
    end

    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end

  # GET /conta_correntes/1
  # GET /conta_correntes/1.json
  def show
  end

  # GET /conta_correntes/new
  def new
    @conta_corrente = ContaCorrente.new
    @conta_corrente.data_alegacao_pagamento = Time.zone.now
  end

  # GET /conta_correntes/1/edit
  def edit
  end

  # POST /conta_correntes
  # POST /conta_correntes.json
  def create
    unless usuario_logado.admin?
      redirect_to conta_correntes_url, error: 'Somente administrador tem acesso a esta operação.'
      return
    end
    
    @conta_corrente = ContaCorrente.new(conta_corrente_params)
    unless usuario_logado.admin?
      @conta_corrente.usuario = usuario_logado
    end

    respond_to do |format|
      if @conta_corrente.save
        unless usuario_logado.admin?
          @conta_corrente.usuario = usuario_logado
        end
      
        format.html { redirect_to conta_correntes_url, notice: 'Conta corrente foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @conta_corrente }
      else
        format.html { render :new }
        format.json { render json: @conta_corrente.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conta_correntes/1
  # PATCH/PUT /conta_correntes/1.json
  def update
    unless usuario_logado.admin?
      redirect_to conta_correntes_url, error: 'Somente administrador tem acesso a esta operação.'
      return
    end

    respond_to do |format|
      if @conta_corrente.update(conta_corrente_params)
        format.html { redirect_to conta_correntes_url, notice: 'Conta corrente foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @conta_corrente }
      else
        format.html { render :edit }
        format.json { render json: @conta_corrente.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conta_correntes/1
  # DELETE /conta_correntes/1.json
  def destroy
    unless usuario_logado.admin?
      redirect_to conta_correntes_url, error: 'Somente administrador tem acesso a esta operação.'
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
