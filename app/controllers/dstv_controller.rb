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

  def pagar_fatura
    return flash[:error] = "Customer number não pode ser vazio" if params[:customer_number].blank?
    return flash[:error] = "Valor não pode ser vazio" if params[:valor].blank?
    
    @info = Dstv.pagar_fatura(params[:customer_number], params[:valor], request.remote_ip, usuario_logado)
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
