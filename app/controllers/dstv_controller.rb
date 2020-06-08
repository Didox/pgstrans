class DstvController < ApplicationController
  def validacao_cliente
    if params[:smartcard].present?
      @info = Dstv.informacoes_device_number(params[:smartcard], request.remote_ip)
    elsif params[:numero_cliente].present?
      @info = Dstv.informacoes_customer_number(params[:numero_cliente], request.remote_ip)
    end
  rescue Exception => e
    flash[:error] = e.message
  end

  def consulta_fatura
   
  end

  def alteracao_cliente_produtos
    @produtos = Dstv.produtos
  end

  def alteracao_pacote
    
  end

  def alteracao_plano
  end
end
