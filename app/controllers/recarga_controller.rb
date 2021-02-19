class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda], request.ip)
    begin
      if venda.sucesso?
        render json: {mensagem: venda.status_desc.error_description_pt, status: venda.status}, status: 200
      else
        LogVenda.create(usuario_id: usuario_logado.id, titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: venda.status_desc.error_description_pt)
        render json: {mensagem: venda.status_desc.error_description_pt, status: venda.status}, status: 401
      end
    rescue Exception => erro
      LogVenda.create(usuario_id: usuario_logado.id,titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
      mensagem = erro.message
      mensagem = erro.message.to_s.split("-").first if Rails.env == "production" && (erro.message.to_s.split("-").length rescue 0) > 0
      render json: {mensagem: mensagem, status:401}, status: 401
    end
  rescue Exception => erro
    LogVenda.create(usuario_id: usuario_logado.id,titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
    mensagem = erro.message
    mensagem = erro.message.to_s.split("-").first if Rails.env == "production" && (erro.message.to_s.split("-").length rescue 0) > 0
    render json: {mensagem: mensagem, status:401}, status: 401
  end
end