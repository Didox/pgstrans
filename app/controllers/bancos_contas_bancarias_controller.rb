class BancosContasBancariasController < ApplicationController
  def index_bancos_clientes
    @bancos = Banco.all.order(ordem_prioridade: :asc)
    
    options = {page: params[:page] || 1, per_page: 10}
    @bancos = @bancos.paginate(options)  

    @bancos = @bancos.where("nome ilike '%#{params[:nome]}%'") if params[:nome].present?
    @bancos = @bancos.where("sigla ilike '%#{params[:sigla]}%'") if params[:sigla].present?
    @bancos = @bancos.where("iban ilike '%#{params[:iban]}%'") if params[:iban].present?
    @bancos = @bancos.where("conta_bancaria ilike '%#{params[:conta_bancaria]}%'") if params[:conta_bancaria].present?
    @bancos = @bancos.where(status_banco_id: Banco::ATIVO)
  end
end
