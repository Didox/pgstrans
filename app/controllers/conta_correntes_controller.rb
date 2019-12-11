class ContaCorrentesController < ApplicationController
  before_action :set_conta_corrente, only: [:show, :edit, :update, :destroy]

  # GET /conta_correntes
  # GET /conta_correntes.json
  def index
    @conta_correntes = ContaCorrente.all
  end

  # GET /conta_correntes/1
  # GET /conta_correntes/1.json
  def show
  end

  # GET /conta_correntes/new
  def new
    @conta_corrente = ContaCorrente.new
  end

  # GET /conta_correntes/1/edit
  def edit
  end

  # POST /conta_correntes
  # POST /conta_correntes.json
  def create
    @conta_corrente = ContaCorrente.new(conta_corrente_params)

    respond_to do |format|
      if @conta_corrente.save
        format.html { redirect_to @conta_corrente, notice: 'Conta corrente was successfully created.' }
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
    respond_to do |format|
      if @conta_corrente.update(conta_corrente_params)
        format.html { redirect_to @conta_corrente, notice: 'Conta corrente was successfully updated.' }
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
    @conta_corrente.destroy
    respond_to do |format|
      format.html { redirect_to conta_correntes_url, notice: 'Conta corrente was successfully destroyed.' }
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
      params.require(:conta_corrente).permit(:usuario_id, :lancamento_id, :banco_id, :valor, :iban, :data_alegacao_pagamento, :saldo_anterior, :saldo_atual, :data_ultima_atualizacao_saldo)
    end
end
