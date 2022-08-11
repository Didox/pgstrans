class AfricellController < ApplicationController
  def impressao_recibo
    if params[:target_msisdn].present?
      @venda = Venda.where(customer_number: params[:target_msisdn], partner_id: Partner.africell.id).first
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

end
