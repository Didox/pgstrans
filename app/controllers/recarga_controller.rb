class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma_api
    params[:api] = "v1"
    confirma
  end

  def confirma_api_v2
    params[:api] = "v2"
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda], request.ip)
    token, data = venda.token_e_data_ende
    if venda.sucesso?
      render json: {
        code: venda.status_desc.codigo_erro_pagaso,
        message: venda.status_desc.error_description_pt,
        status: 200,
        original_message: venda.status_desc.error_description,
        sell_id: venda.id,
        recharge_token: token,
        date_recharge_token: data,
        redirect: venda.partner_id == Partner.ende.id
      }, status: 200
    else
      LogVenda.create(usuario_id: usuario_logado.id, titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{venda.status_desc.error_description_pt} - #{venda.status} - #{venda.response_get}")
      
      render json: {
        code: venda.status_desc.codigo_erro_pagaso,
        message: "#{venda.status_desc.error_description_pt} - #{venda.error_message}", 
        status: 401,
        original_message: venda.status_desc.error_description, 
        sell_id: venda.id, 
        redirect: venda.partner_id == Partner.ende.id
        }, status: 401
    end
  rescue Exception => erro
    
    mensagem = mensagem_dos_parametros_com_erro(erro)
    mensagem_original = mensagem

    code = "PGS_ERRO_RECARGA_0001"
    code = "PGS_ERRO_TIMEOUT_0001" if mensagem.downcase.include?("timeout")

    return_code = busca_return_code_params(mensagem)

    if return_code.present?
      code = return_code.codigo_erro_pagaso
      mensagem = return_code.error_description_pt
      mensagem_original = return_code.error_description
    end

    Rails.logger.info(mensagem)
    render json: {
      code: code,
      message: mensagem, 
      status: 400,
      original_message: mensagem_original, 
      sell_id: nil, 
      redirect:false
    }, status: 400
  end
  
  def confirma
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda], request.ip)
    token, data = venda.token_e_data_ende
    if venda.sucesso?
        render json: {
          mensagem: venda.status_desc.error_description_pt, 
          token_recarga: token, 
          data_token_recarga: data, 
          status: venda.status, 
          venda_id: venda.id, 
          sucesso: venda.sucesso?, 
          redirect: venda.partner_id == Partner.ende.id
        }, status: 200
    else
      LogVenda.create(usuario_id: usuario_logado.id, titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{venda.status_desc.error_description_pt} - #{venda.status} - #{venda.response_get}")
      render json: {mensagem: "#{venda.status_desc.error_description_pt} - #{venda.error_message}", status: venda.status, venda_id: venda.id, sucesso: false, redirect: venda.partner_id == Partner.ende.id}, status: 401
    end
  rescue Exception => erro
    mensagem = mensagem_dos_parametros_com_erro(erro)
    mensagem_original = mensagem
    return_code = busca_return_code_params(mensagem)
    if return_code.present?
      mensagem = return_code.error_description_pt
      mensagem_original = return_code.error_description
    end
    render json: {
      mensagem: mensagem,
      original_mensagem: mensagem_original,
      status:401,
      sucesso: false
    }, status: 401
  end

  private
  def busca_return_code_params(mensagem)
    if params[:produto_id].present?
      produto = Produto.find(params[:produto_id]) rescue nil
      parceiro_id = produto&.partner_id
    end

    mensagem_busca = mensagem.split("-").first.to_s.strip rescue mensagem
    ReturnCodeApi.where("error_description ilike ?", "%#{mensagem_busca}%").where(partner_id: parceiro_id).first 
  end

  def mensagem_dos_parametros_com_erro(erro)
    LogVenda.create(usuario_id: usuario_logado.id,titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
    mensagem = erro.message
    mensagem = erro.message.to_s.split("-").first if Rails.env == "production" && (erro.message.to_s.split("-").length rescue 0) > 0
    mensagem
  end
end