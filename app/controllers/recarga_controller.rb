class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma
    venda = Venda.fazer_venda(params, usuario_logado, params[:tipo_venda])
    begin
      if venda.sucesso?
        render json: {mensagem: venda.status_desc.error_description_pt}, status: 200
      else
        render json: {mensagem: venda.status_desc.error_description_pt, erro: venda.response_get}, status: 401
      end
    rescue Exception => erro
      render json: {mensagem: venda.status_desc.error_description_pt, erro: erro.message}, status: 401
    end
  rescue Exception => erro
    render json: {mensagem: venda.status_desc.error_description_pt, erro: erro.message}, status: 401
  end
end