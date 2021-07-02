class PagamentosFaturasDstvsController < ApplicationController
  def index
    @pagamentos_faturas_dstvs = Venda.all.order("id desc")

    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("customer_number ilike '%#{params[:customer_number].remove_injection}%'") if params[:customer_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("smartcard ilike '%#{params[:smartcard].remove_injection}%'") if params[:smartcard].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("receipt_number ilike '%#{params[:receipt_number].remove_injection}%'") if params[:receipt_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time].remove_injection}%'") if params[:transaction_date_time].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("lancamento_id = ?", Lancamento.where(nome: Lancamento::PAGAMENTO_DE_FATURA).first)
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("partner_id = ?", Partner.dstv)

    @pagamentos_faturas_dstvs_total = @pagamentos_faturas_dstvs.count
    options = {page: params[:page] || 1, per_page: 10}
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.paginate(options)
  end

  def resumido
    @pagamentos_faturas_dstvs = Venda.all.order("id desc")

    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("customer_number ilike '%#{params[:customer_number].remove_injection}%'") if params[:customer_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("smartcard ilike '%#{params[:smartcard].remove_injection}%'") if params[:smartcard].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("receipt_number ilike '%#{params[:receipt_number].remove_injection}%'") if params[:receipt_number].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time].remove_injection}%'") if params[:transaction_date_time].present?
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("lancamento_id = ?", Lancamento.where(nome: Lancamento::PAGAMENTO_DE_FATURA).first)
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.where("partner_id = ?", Partner.dstv)

    @pagamentos_faturas_dstvs_valor = @pagamentos_faturas_dstvs.sum(:value)
    options = {page: params[:page] || 1, per_page: 10}
    @pagamentos_faturas_dstvs = @pagamentos_faturas_dstvs.paginate(options)
  end

  def show
  end

  def new
    redirect_to "/pagamentos_faturas_dstvs"
  end

  def edit
    redirect_to "/pagamentos_faturas_dstvs"
  end

  def create
    redirect_to "/pagamentos_faturas_dstvs"
  end

  def update
    redirect_to "/pagamentos_faturas_dstvs"
  end

  def destroy
    redirect_to "/pagamentos_faturas_dstvs"
  end
end
