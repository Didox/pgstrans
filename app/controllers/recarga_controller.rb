class RecargaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def confirma
    venda = Venda.fazer_venda(params)
    begin
      status = venda.response_get_parse[:status].to_i
      if (200..300).include?(status)
        render json: {mensagem: "Recarga efetuada com sucesso!"}, status: 200
      else
        render json: {mensagem: "Falha ao efetuar recarga", erro: venda.response_get}, status: 401
      end
    rescue Exception => erro
      render json: {mensagem: "Falha ao efetuar recarga", erro: erro.message}, status: 401
    end
  rescue Exception => erro
    render json: {mensagem: "Falha ao efetuar recarga", erro: erro.message}, status: 401
  end
end