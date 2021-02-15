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
    flash[:mensagem_erro_fatura] = e.message
  end

  def pagar_fatura
    return flash[:error] = "Customer number não pode ser vazio" if params[:customer_number].blank?
    return flash[:error] = "Smartcard não pode ser vazio" if params[:smartcard].blank?
    return flash[:error] = "Valor não pode ser vazio" if params[:valor].blank?
    
    @info = Dstv.pagar_fatura(params[:customer_number], params[:valor], request.remote_ip, usuario_logado, params[:smartcard])
  rescue Exception => e
    flash[:mensagem_erro_fatura] = e.message
  end

  def alteracao_cliente_produtos
    Dstv.importa_produtos(params[:customer_number], request.remote_ip)
    @produtos = Dstv.produtos_ativos
  rescue Exception => e
    flash[:mensagem_erro_fatura] = e.message
  end

  def alteracao_pacote;end
  def alteracao_pacote_fazer
    return flash[:error] = "Selecione pelo menos um produto" if params[:produtos].blank?
    return flash[:error] = "Permitida a escolha de até 2 produtos" if params[:produtos].length > 2
    return flash[:error] = "Customer number não pode ser vazio" if params[:customer_number].blank?
    return flash[:error] = "Smartcard não pode ser vazio" if params[:smartcard].blank?
    @info = Dstv.alterar_pacote(params[:customer_number], params[:smartcard], params[:produtos], request.remote_ip, usuario_logado)
  rescue Exception => e
    flash[:mensagem_erro_fatura] = e.message
  end

  def alteracao_plano_mensal_anual;end
  def alteracao_plano_mensal_anual_efetivar
    return flash[:error] = "Selecione o produto" if params[:produto_id_parceiro].blank?
    return flash[:error] = "Customer number não pode ser vazio" if params[:customer_number].blank?
    return flash[:error] = "Tipo de plano não pode ser vazio" if params[:tipo_plano].blank?
    @info = Dstv.alteracao_plano_mensal_anual(params[:produto_id_parceiro], params[:customer_number], params[:tipo_plano], request.remote_ip, usuario_logado)
  rescue Exception => e
    flash[:mensagem_erro_fatura] = e.message
  end
  
end
