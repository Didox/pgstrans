class AfricellController < ApplicationController
  def impressao_recibo
    if params[:target_msisdn].present?
      if params[:target_msisdn][0, 5] != "24495"
        numero_africell = "24495".to_s + params[:target_msisdn].to_s
      else
        numero_africell = params[:target_msisdn]
      end
      @venda = Venda.where(customer_number: numero_africell, partner_id: Partner.africell.id).first
      flash[:error] = "Nenhuma venda encontrada" if @venda.blank?
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def confirmacao_transacao
    if params[:target_msisdn].present?
      @venda = Venda.where(customer_number: params[:target_msisdn], partner_id: Partner.africell.id)
    end
    if params[:request_id].present?
      @venda = Venda.where(request_id: params[:request_id], partner_id: Partner.africell.id)
      request = Africell.check_transaction_log(params)
      puts "===========[#{request.body}]============="
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end
end
