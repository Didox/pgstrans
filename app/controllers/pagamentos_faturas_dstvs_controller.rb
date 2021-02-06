class PagamentosFaturasDstvsController < ApplicationController
  before_action :set_pagamentos_faturas_dstv, only: [:show, :edit, :update, :destroy]

  # GET /pagamentos_faturas_dstvs
  # GET /pagamentos_faturas_dstvs.json
  def index
    @pagamentos_faturas_dstvs = PagamentosFaturasDstv.all.order("id desc")

    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("customer_number ilike '%#{params[:customer_number]}%'") if params[:customer_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("smartcard ilike '%#{params[:smartcard]}%'") if params[:smartcard].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("receipt_number ilike '%#{params[:receipt_number]}%'") if params[:receipt_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time]}%'") if params[:transaction_date_time].present?

    options = {page: params[:page] || 1, per_page: 10}
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.paginate(options)
  end

  def resumido
    @pagamentos_faturas_dstvs = PagamentosFaturasDstv.all.order("id desc")

    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("customer_number ilike '%#{params[:customer_number]}%'") if params[:customer_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("smartcard ilike '%#{params[:smartcard]}%'") if params[:smartcard].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("receipt_number ilike '%#{params[:receipt_number]}%'") if params[:receipt_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time]}%'") if params[:transaction_date_time].present?

    options = {page: params[:page] || 1, per_page: 10}
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.paginate(options)
  end

  # GET /pagamentos_faturas_dstvs/1
  # GET /pagamentos_faturas_dstvs/1.json
  def show
  end

  # GET /pagamentos_faturas_dstvs/new
  def new
    redirect_to "/pagamentos_faturas_dstvs"
    return
    @pagamentos_faturas_dstv = PagamentosFaturasDstv.new
  end

  # GET /pagamentos_faturas_dstvs/1/edit
  def edit
    redirect_to "/pagamentos_faturas_dstvs"
    return
  end

  # POST /pagamentos_faturas_dstvs
  # POST /pagamentos_faturas_dstvs.json
  def create
    redirect_to "/pagamentos_faturas_dstvs"
    return
    @pagamentos_faturas_dstv = PagamentosFaturasDstv.new(pagamentos_faturas_dstv_params)

    respond_to do |format|
      if @pagamentos_faturas_dstv.save
        format.html { redirect_to @pagamentos_faturas_dstv, notice: 'Pagamentos faturas dstv foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @pagamentos_faturas_dstv }
      else
        format.html { render :new }
        format.json { render json: @pagamentos_faturas_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pagamentos_faturas_dstvs/1
  # PATCH/PUT /pagamentos_faturas_dstvs/1.json
  def update
    redirect_to "/pagamentos_faturas_dstvs"
    return
    respond_to do |format|
      if @pagamentos_faturas_dstv.update(pagamentos_faturas_dstv_params)
        format.html { redirect_to @pagamentos_faturas_dstv, notice: 'Pagamentos faturas dstv foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @pagamentos_faturas_dstv }
      else
        format.html { render :edit }
        format.json { render json: @pagamentos_faturas_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pagamentos_faturas_dstvs/1
  # DELETE /pagamentos_faturas_dstvs/1.json
  def destroy
    redirect_to "/pagamentos_faturas_dstvs"
    return
    @pagamentos_faturas_dstv.destroy
    respond_to do |format|
      format.html { redirect_to pagamentos_faturas_dstvs_url, notice: 'Pagamentos faturas dstv foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pagamentos_faturas_dstv
      @pagamentos_faturas_dstv = PagamentosFaturasDstv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pagamentos_faturas_dstv_params
      params.require(:pagamentos_faturas_dstv).permit(:request_body, :response_body, :customer_number, :valor, :smartcard, :administrador_id, :receipt_number, :transaction_number, :status, :transaction_date_time, :audit_reference_number)
    end
end
