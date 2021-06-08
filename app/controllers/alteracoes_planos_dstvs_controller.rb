class AlteracoesPlanosDstvsController < ApplicationController
  before_action :set_alteracoes_planos_dstv, only: [:show, :edit, :update, :destroy]

  # GET /alteracoes_planos_dstvs
  # GET /alteracoes_planos_dstvs.json
  def index
    @alteracoes_planos_dstvs = AlteracoesPlanosDstv.all.order("id desc")

    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("customer_number ilike '%#{params[:customer_number]}%'") if params[:customer_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("smartcard ilike '%#{params[:smartcard]}%'") if params[:smartcard].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("receipt_number ilike '%#{params[:receipt_number]}%'") if params[:receipt_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time]}%'") if params[:transaction_date_time].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("tipo_plano = ?", params[:tipo_plano]) if params[:tipo_plano].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_number ilike '%#{params[:transaction_number]}%'") if params[:transaction_number].present?

    @alteracoes_planos_dstvs_total = @alteracoes_planos_dstvs.count
    options = {page: params[:page] || 1, per_page: 10}
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.paginate(options)
  end

  def resumido
    @alteracoes_planos_dstvs = AlteracoesPlanosDstv.all.order("id desc")

    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("customer_number ilike '%#{params[:customer_number]}%'") if params[:customer_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("smartcard ilike '%#{params[:smartcard]}%'") if params[:smartcard].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("receipt_number ilike '%#{params[:receipt_number]}%'") if params[:receipt_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time]}%'") if params[:transaction_date_time].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("tipo_plano = ?", params[:tipo_plano]) if params[:tipo_plano].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_number ilike '%#{params[:transaction_number]}%'") if params[:transaction_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.joins("inner join usuarios on alteracoes_planos_dstvs.usuario_id = usuarios.id ")

    if params[:login].present?
      @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lower(usuarios.login) like ? ", "%#{params[:login].downcase}%")
    end

    if params[:nome].present?
      @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lower(usuarios.nome) like ? ", "%#{params[:nome].downcase}%")
    end

    @alteracoes_planos_dstvs_valor = @alteracoes_planos_dstvs.sum(:valor)  
    options = {page: params[:page] || 1, per_page: 10}
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.paginate(options)
  end

  # GET /alteracoes_planos_dstvs/1
  # GET /alteracoes_planos_dstvs/1.json
  def show
  end

  # GET /alteracoes_planos_dstvs/new
  def new
    redirect_to "/alteracoes_planos_dstvs"
    return
    @alteracoes_planos_dstv = AlteracoesPlanosDstv.new
  end

  # GET /alteracoes_planos_dstvs/1/edit
  def edit
    redirect_to "/alteracoes_planos_dstvs"
    return
  end

  # POST /alteracoes_planos_dstvs
  # POST /alteracoes_planos_dstvs.json
  def create
    redirect_to "/alteracoes_planos_dstvs"
    return
    @alteracoes_planos_dstv = AlteracoesPlanosDstv.new(alteracoes_planos_dstv_params)

    respond_to do |format|
      if @alteracoes_planos_dstv.save
        format.html { redirect_to @alteracoes_planos_dstv, notice: 'Alteracoes planos dstv foi criado com sucesso.' }
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
    redirect_to "/alteracoes_planos_dstvs"
    return
    respond_to do |format|
      if @alteracoes_planos_dstv.update(alteracoes_planos_dstv_params)
        format.html { redirect_to @alteracoes_planos_dstv, notice: 'Alteracoes planos dstv foi atualizado com sucesso.' }
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
    redirect_to "/alteracoes_planos_dstvs"
    return
    @alteracoes_planos_dstv.destroy
    respond_to do |format|
      format.html { redirect_to alteracoes_planos_dstvs_url, notice: 'Alteracoes planos dstv foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    
    def set_alteracoes_planos_dstv
      @alteracoes_planos_dstv = AlteracoesPlanosDstv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alteracoes_planos_dstv_params
      params.require(:alteracoes_planos_dstv).permit(:request_body, :response_body, :customer_number, :smartcard, :produto, :administrador_id, :produto, :codigo, :valor, :receipt_number, :transaction_number, :status, :transaction_date_time, :error_message, :audit_reference_number)
    end
end
