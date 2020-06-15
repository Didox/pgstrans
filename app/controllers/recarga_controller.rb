class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda])
    begin
      if venda.sucesso?
        render json: {mensagem: venda.status_desc.error_description_pt}, status: 200
      else
        LogVenda.create(titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: venda.status_desc.error_description_pt)
        render json: {mensagem: venda.status_desc.error_description_pt}, status: 401
      end
    rescue Exception => erro
      LogVenda.create(titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
      render json: {mensagem: erro.message}, status: 401
    end
  rescue Exception => erro
    LogVenda.create(titulo: "#{params[:tipo_venda]} - Tentativa de venda dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: "#{erro.message} - #{erro.backtrace}")
    render json: {mensagem: erro.message}, status: 401
  end
end