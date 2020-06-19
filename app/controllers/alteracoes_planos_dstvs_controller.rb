class AlteracoesPlanosDstvsController < ApplicationController
  before_action :set_alteracoes_planos_dstv, only: [:show, :edit, :update, :destroy]

  # GET /alteracoes_planos_dstvs
  # GET /alteracoes_planos_dstvs.json
  def index
    @alteracoes_planos_dstvs = AlteracoesPlanosDstv.all
  end

  # GET /alteracoes_planos_dstvs/1
  # GET /alteracoes_planos_dstvs/1.json
  def show
  end

  # GET /alteracoes_planos_dstvs/new
  def new
    @alteracoes_planos_dstv = AlteracoesPlanosDstv.new
  end

  # GET /alteracoes_planos_dstvs/1/edit
  def edit
  end

  # POST /alteracoes_planos_dstvs
  # POST /alteracoes_planos_dstvs.json
  def create
    @alteracoes_planos_dstv = AlteracoesPlanosDstv.new(alteracoes_planos_dstv_params)

    respond_to do |format|
      if @alteracoes_planos_dstv.save
        format.html { redirect_to @alteracoes_planos_dstv, notice: 'Alteracoes planos dstv was successfully created.' }
        format.json { render :show, status: :created, location: @alteracoes_planos_dstv }
      else
        format.html { render :new }
        format.json { render json: @alteracoes_planos_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alteracoes_planos_dstvs/1
  # PATCH/PUT /alteracoes_planos_dstvs/1.json
  def update
    respond_to do |format|
      if @alteracoes_planos_dstv.update(alteracoes_planos_dstv_params)
        format.html { redirect_to @alteracoes_planos_dstv, notice: 'Alteracoes planos dstv was successfully updated.' }
        format.json { render :show, status: :ok, location: @alteracoes_planos_dstv }
      else
        format.html { render :edit }
        format.json { render json: @alteracoes_planos_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alteracoes_planos_dstvs/1
  # DELETE /alteracoes_planos_dstvs/1.json
  def destroy
    @alteracoes_planos_dstv.destroy
    respond_to do |format|
      format.html { redirect_to alteracoes_planos_dstvs_url, notice: 'Alteracoes planos dstv was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alteracoes_planos_dstv
      @alteracoes_planos_dstv = AlteracoesPlanosDstv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alteracoes_planos_dstv_params
      params.require(:alteracoes_planos_dstv).permit(:request_body, :response_body, :customer_number, :smartcard, :produto, :administrador_id, :produto, :codigo, :valor, :receipt_number, :transaction_number, :status, :transaction_date_time, :error_message, :audit_reference_number)
    end
end
