class ElephantBetController < ApplicationController
   layout "basico", only: [:consultar_voucher_mini]

   def consultar_voucher_mini
      consultar_voucher
   rescue Exception => e
      flash[:error] = e.message
   end

    def consultar_voucher
      if params[:transaction_reference].present? 
         if params[:transaction_reference].present?
            @venda = Venda.where(transaction_reference: params[:transaction_reference], partner_id: Partner.elephantbet.id).first
            @info = ElephantBet.consultar_voucher_reference(params[:transaction_reference])
         end
         #flash[:error] = "Nenhum voucher encontrado com o parämetro fornecido" if @info.blank? || @venda.blank?
         return
      end

      if params[:payment_code].present?
         if params[:payment_code].present?
            @venda = Venda.where(payment_code: params[:payment_code], partner_id: Partner.elephantbet.id).first
            @info = ElephantBet.consultar_voucher_payment_code(params[:payment_code])
         end
         #flash[:error] = "Nenhum voucher encontrado com o parämetros fornecido" if @info.blank? || @venda.blank?
      end

   rescue Exception => e
      flash[:error] = e.message
   end

end