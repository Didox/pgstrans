class Venda < ApplicationRecord
  default_scope { order(updated_at: :desc) }
  belongs_to :usuario
  belongs_to :partner

  def request_send_parse
    JSON.parse(self.request_send.gsub(/\n|\t/, ""))
  end

  def response_get_parse
    JSON.parse(self.response_get.gsub(/\n|\t/, ""))
  rescue
    {}
  end

  def status
    ReturnCodeApi.where(return_code: self.response_get_parse["statusCode"], partner_id: self.partner_id).first || ReturnCodeApi.new(error_description_pt: "Status não localizado")
  rescue
    ReturnCodeApi.new(error_description_pt: "Status não localizado")
  end

  def self.fazer_venda(params, usuario)
    parceiro = Partner.where(slug: "unitel").first

    raise "Parceiro não localizado" if parceiro.blank?
    raise "Produto não selecionado" if params[:unitel_produto_id].blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o telefone" if params[:unitel_telefone].blank?

    product_id = params[:unitel_produto_id].split("-").first
    telefone = params[:unitel_telefone]
    valor = params[:valor].to_i

    venda = Venda.create(agent_id: AGENTE_ID, product_id: product_id, value: valor, client_msisdn: telefone, usuario_id: usuario.id, parceiro_id: parceiro.id)

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    retorno = `./chaves/exec.sh #{venda.id} #{venda.product_id} #{venda.agent_id} #{venda.store_id} #{venda.seller_id} #{venda.terminal_id} #{valor} #{venda.client_msisdn}`
    venda.request_send, venda.response_get = retorno.split(" --- ")

    venda.save!

    venda
  end
end
