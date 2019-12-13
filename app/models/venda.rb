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

  def status_desc
    ReturnCodeApi.where(return_code: self.status, partner_id: self.partner_id).first || ReturnCodeApi.new(error_description_pt: "Status não localizado")
  rescue
    ReturnCodeApi.new(error_description_pt: "Status não localizado")
  end

  def sucesso?
    self.status == "0"
  end

  def self.fazer_venda(params, usuario)
    ActiveRecord::Base.transaction do
      parceiro = Partner.where("lower(slug) = 'unitel'").first
      valor = params[:valor].to_i

      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Produto não selecionado" if params[:unitel_produto_id].blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o telefone" if params[:unitel_telefone].blank?
      raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?

      product_id = params[:unitel_produto_id].split("-").first
      telefone = params[:unitel_telefone]

      venda = Venda.create(agent_id: AGENTE_ID, product_id: product_id, value: valor, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)

      venda.store_id = usuario.sub_agente.store_id_parceiro
      venda.seller_id = usuario.sub_agente.seller_id_parceiro
      venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

      retorno = `./chaves/exec.sh #{venda.id} #{venda.product_id} #{venda.agent_id} #{venda.store_id} #{venda.seller_id} #{venda.terminal_id} #{valor} #{venda.client_msisdn}`
      venda.request_send, venda.response_get = retorno.split(" --- ")
      venda.status = venda.response_get_parse["statusCode"] rescue "3"
      venda.save!

      if venda.sucesso?
        ContaCorrente.create!(
          usuario: usuario,
          valor: "-#{valor}",
          observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
          lancamento: Lancamento.where(nome: "Compra de crédito"),
          banco: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
          iban: ContaCorrente.where(usuario_id: usuario.id).first.iban
        )
      end

      return venda
    end
  end
end
