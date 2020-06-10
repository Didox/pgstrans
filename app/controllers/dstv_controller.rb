class DstvController < ApplicationController
  def validacao_cliente
    if params[:smartcard].present?
      @info = Dstv.informacoes_device_number(params[:smartcard], request.remote_ip)
    elsif params[:customer_number].present?
      @info = Dstv.informacoes_customer_number(params[:customer_number], request.remote_ip)
    end
  rescue Exception => e
    flash[:error] = e.message
  end

  def consulta_fatura
    if params[:smartcard].present? && params[:customer_number].present?
      @info = Dstv.consulta_fatura(params[:smartcard], params[:customer_number], request.remote_ip)
    end
  rescue Exception => e
    flash[:error] = e.message
  end

  def alteracao_cliente_produtos
    @produtos = Dstv.produtos
  end

  def alteracao_pacote
    
  end

  def alteracao_plano
  end
end
