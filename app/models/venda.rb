class Venda < ApplicationRecord
  default_scope { order(updated_at: :desc) }

  def request_send_parse
    JSON.parse(self.request_send.gsub(/\n|\t/, ""))
  end

  def response_get_parse
    JSON.parse(self.response_get.gsub(/\n|\t/, ""))
  end

  def self.fazer_venda(params, usuario)
    raise "Produto não selecionado" if params[:unitel_produto_id].blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o telefone" if params[:unitel_telefone].blank?

    product_id = params[:unitel_produto_id].split("-").first
    telefone = params[:unitel_telefone]

    venda = Venda.create(agent_id: AGENTE_ID, product_id: product_id, value: params[:valor], client_msisdn: telefone)

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    retorno = `./chaves/exec.sh #{venda.id} #{venda.product_id} #{venda.agent_id} #{venda.store_id} #{venda.seller_id} #{venda.terminal_id} #{venda.value} #{venda.client_msisdn}`
    venda.request_send, venda.response_get = retorno.split(" --- ")

    venda.save!

    venda
  end
end
