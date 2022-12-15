class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma_api
    confirma
  end

  def confirma_api_v2
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda], request.ip)
    if venda.sucesso?
      render json: {
        code: venda.status_desc.codigo_erro_pagaso,
        message: venda.status_desc.error_description_pt,
        sell_id: venda.id,
        redirect: venda.partner_id == Partner.ende.id,
        status: 200
      }, status: 200
    else
      LogVenda.create(usuario_id: usuario_logado.id, titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{venda.status_desc.error_description_pt} - #{venda.status} - #{venda.response_get}")
      
      render json: {
        code: venda.status_desc.codigo_erro_pagaso,
        message: "#{venda.status_desc.error_description_pt} - #{venda.error_message}", 
        sell_id: venda.id, 
        redirect: venda.partner_id == Partner.ende.id,
        status: 401
        }, status: 401
    end
  rescue Exception => erro
    LogVenda.create(usuario_id: usuario_logado.id,titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
    mensagem = erro.message
    mensagem = erro.message.to_s.split("-").first if Rails.env == "production" && (erro.message.to_s.split("-").length rescue 0) > 0

    code = "PGS_ERRO_RECARGA_0001"
    #mensagem_tratada = "Erro de sistema. Entre em contato com o Administrador"

    if mensagem.downcase.include?("timeout")
      code = "PGS_ERRO_TIMEOUT_RECARGA_0002" 
      #mensagem_tratada = "Timeout. Sem resposta da operadora."
    end

    Rails.logger.info(mensagem)
    render json: {
      code: code,
      message: mensagem, 
      sell_id: nil, 
      redirect:false,
      status: 400
    }, status: 400
  end
  
  def confirma
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda], request.ip)
    if venda.sucesso?
      render json: {mensagem: venda.status_desc.error_description_pt, status: venda.status, venda_id: venda.id, sucesso: venda.sucesso?, redirect: venda.partner_id == Partner.ende.id}, status: 200
    else
      LogVenda.create(usuario_id: usuario_logado.id, titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{venda.status_desc.error_description_pt} - #{venda.status} - #{venda.response_get}")
      render json: {mensagem: "#{venda.status_desc.error_description_pt} - #{venda.error_message}", status: venda.status, venda_id: venda.id, sucesso: false, redirect: venda.partner_id == Partner.ende.id}, status: 401
    end
  rescue Exception => erro
    LogVenda.create(usuario_id: usuario_logado.id,titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
    mensagem = erro.message
    mensagem = erro.message.to_s.split("-").first if Rails.env == "production" && (erro.message.to_s.split("-").length rescue 0) > 0
    render json: {mensagem: mensagem, status:401, sucesso: false}, status: 401
  end
end