class AfricellController < ApplicationController
  def impressao_recibo
    if params[:target_msisdn].present?
      @venda = Venda.where(customer_number: params[:target_msisdn], partner_id: Partner.africell.id).first
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
    end
    if params[:created_at].present?
      @venda = Venda.where(created_at: params[:created_at], partner_id: Partner.africell.id)
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end
end
