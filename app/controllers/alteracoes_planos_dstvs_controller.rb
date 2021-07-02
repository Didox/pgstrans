class AlteracoesPlanosDstvsController < ApplicationController
  def index
    @alteracoes_planos_dstvs = Venda.all.order("id desc")

    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("customer_number ilike '%#{params[:customer_number].remove_injection}%'") if params[:customer_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("smartcard ilike '%#{params[:smartcard].remove_injection}%'") if params[:smartcard].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("receipt_number ilike '%#{params[:receipt_number].remove_injection}%'") if params[:receipt_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time].remove_injection}%'") if params[:transaction_date_time].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("tipo_plano = ?", params[:tipo_plano]) if params[:tipo_plano].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_number ilike '%#{params[:transaction_number].remove_injection}%'") if params[:transaction_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("partner_id = ?", Partner.dstv)
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lancamento_id in (?) or lancamento_id is null", Lancamento.where("nome in (?)", [Lancamento::ALTERACAO_PLANO, Lancamento::ALTERACAO_PACOTE]).map{|l| l.id} )

    @alteracoes_planos_dstvs_total = @alteracoes_planos_dstvs.count
    options = {page: params[:page] || 1, per_page: 10}
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.paginate(options)
  end

  def resumido
    @alteracoes_planos_dstvs = Venda.all.order("id desc")

    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("customer_number ilike '%#{params[:customer_number].remove_injection}%'") if params[:customer_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("smartcard ilike '%#{params[:smartcard].remove_injection}%'") if params[:smartcard].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("receipt_number ilike '%#{params[:receipt_number].remove_injection}%'") if params[:receipt_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_date_time ilike '%#{params[:transaction_date_time].remove_injection}%'") if params[:transaction_date_time].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("tipo_plano = ?", params[:tipo_plano]) if params[:tipo_plano].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("transaction_number ilike '%#{params[:transaction_number].remove_injection}%'") if params[:transaction_number].present?
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.joins("inner join usuarios on alteracoes_planos_dstvs.usuario_id = usuarios.id ")
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("partner_id = ?", Partner.dstv)
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lancamento_id in (?) or lancamento_id is null", Lancamento.where("nome in (?)", [Lancamento::ALTERACAO_PLANO, Lancamento::ALTERACAO_PACOTE]).map{|l| l.id} )

    if params[:login].present?
      @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lower(usuarios.login) like ? ", "%#{params[:login].downcase}%")
    end

    if params[:nome].present?
      @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.where("lower(usuarios.nome) like ? ", "%#{params[:nome].downcase}%")
    end

    @alteracoes_planos_dstvs_valor = @alteracoes_planos_dstvs.sum(:value)  
    options = {page: params[:page] || 1, per_page: 10}
    @alteracoes_planos_dstvs = @alteracoes_planos_dstvs.paginate(options)
  end

  def show
  end

  def new
    redirect_to "/alteracoes_planos_dstvs"
  end

  def edit
    redirect_to "/alteracoes_planos_dstvs"
  end

  def create
    redirect_to "/alteracoes_planos_dstvs"
  end

  def update
    redirect_to "/alteracoes_planos_dstvs"
  end

  def destroy
    redirect_to "/alteracoes_planos_dstvs"
  end
end
