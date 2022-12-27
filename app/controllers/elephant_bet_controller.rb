class ElephantBetController < ApplicationController

    def consultar_voucher
        if params[:transaction_reference].present? 
           @venda = Venda.where(transaction_reference: transaction_reference, partner_id: Partner.elephantbet.id).first if params[:transaction_reference].present?
           flash[:error] = "Nenhum voucher encontrado com o parämetro fornecido" if @venda.blank?
        end
        if params[:payment_code].present?
            @venda = Venda.where(payment_code: payment_code, partner_id: Partner.elephantbet.id).first if params[:payment_code].present?
            flash[:error] = "Nenhum voucher encontrado com o parämetros fornecido" if @venda.blank?
         end
      rescue Exception => e
        flash[:error] = e.message
        @info = []
      end

end