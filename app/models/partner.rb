class Partner < ApplicationRecord
  has_many :return_code_api
  validates :name, presence: true, uniqueness: true
  belongs_to :status_parceiro
  default_scope { order(order: :asc) }

  STORE_ID_ZAP_PARCEIRO = "115356"

  def importa_produtos!
    return if self.slug.downcase != "zaptv"

    parametro = Parametro.where(partner_id: self.id).first

    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}/portfolio"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}/portfolio"
      api_key = parametro.api_key_zaptv_producao
    end

    res = HTTParty.get(
      host, 
      headers: {
        apikey: api_key
      }
    )

    if (200...300).include?(res.code)
      dados = JSON.parse(res.body)
      dados.each do |p_hash|
        produtos = Produto.where(produto_id_parceiro: p_hash["code"], partner_id: self.id)
        if produtos.count == 0
          produto = Produto.new
          produto.produto_id_parceiro = p_hash["code"]
          produto.partner_id = self.id
        else
          produto = produtos.first
        end

        produto.description = p_hash["description"]
        produto.valor_minimo_venda_site = p_hash["price"]
        produto.valor_compra_site = p_hash["price"]
        produto.valor_compra_telemovel = p_hash["price"]
        produto.valor_minimo_venda_telemovel = p_hash["price"]
        
        # TODO ::: Verificar se um dia iremos utilizar :::
        # produto.name = p_hash["recomended_quantity"]
        # produto.name = p_hash["unit"]
        # produto.name = p_hash["unit_pl"]
        produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{p_hash["currency"]}')").first.id
        produto.subtipo = p_hash["technology"]
        produto.status_produto = StatusProduto.where(nome: "Ativo").first

        produto.save
      end
    end

    item = UltimaAtualizacaoProduto.where(partner_id: self.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      UltimaAtualizacaoProduto.create(partner_id: self.id)
    end
  end

  def importa_dados!
    return if self.slug.downcase != "zaptv"

    parametro = Parametro.where(partner_id: self.id).first
    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}"
      api_key = parametro.api_key_zaptv_producao
    end

    ###### Entender se realmente não precisamos passar este id
    # partner.STORE_ID_ZAP_PARCEIRO # "115356"
    ############################################################
    data = Time.zone.now - 20.days
    while data <= Time.zone.now
      url = "#{host}/carregamento/report/#{data.strftime("%Y-%m-%d")}"
      data = data + 1.day

      Rails.logger.info ":::: (#{url}) ::::"

      res = HTTParty.get(
        url, 
        headers: {
          "apikey" => api_key,
          "Content-Type" => "application/json"
        }
      )

      if (200..300).include?(res.code)
        dados = JSON.parse(res.body)
        RelatorioConciliacaoZaptv.where(url: url).destroy_all if dados.length > 0
        dados.each do |dado|
          rel = RelatorioConciliacaoZaptv.new

          rel.partner_id = self.id
          rel.url = url
          rel.operation_code = dado["operation_code"]
          rel.source_reference = dado["source_reference"]
          rel.product_code = dado["product_code"]
          rel.quantity = dado["quantity"]
          rel.date_time = dado["datetime"]
          rel.type_data = dado["type"]
          rel.total_price = dado["total_price"]
          rel.status = dado["status"]
          rel.unit_price = dado["unit_price"]
          rel.save

          Rails.logger.info ":::: Relatório criado (#{rel.id}) ::::"
        end
      else
        Rails.logger.info ":::: Não encontrado (#{res.body}) ::::"
      end
    end

    item = UltimaAtualizacaoReconciliacao.where(partner_id: self.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      UltimaAtualizacaoReconciliacao.create(partner_id: self.id)
    end
  end

  def saldo_atual_movicel
    parceiro = Partner.where("lower(slug) = 'movicel'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url_service = parametro.url_integracao_desenvolvimento
      agent_key = parametro.agent_key_movicel_desenvolvimento
    else
      url_service = parametro.url_integracao_producao
      agent_key = parametro.agent_key_movicel_producao
    end

    host = url_service.to_s.gsub(/o\:.*/, "o")

    require 'openssl'

    user_id = "TivTechno"
    request_id = Time.now.strftime("%d%m%Y%H%M%S")

    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
    # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
    pass = pass.strip

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"#{host}/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\">
        <soapenv:Header>
          <int:QueryBalanceReqHeader>
              <mid:RequestId>#{request_id}</mid:RequestId>
              <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
              <!--Optional:-->
              <mid:SourceSystem>#{user_id}</mid:SourceSystem>
              <mid:Credentials>
                <mid:User>#{user_id}</mid:User>
                <mid:Password>#{pass}</mid:Password>
              </mid:Credentials>
              <!--Optional:-->
              <mid:Attributes>
                <!--Zero or more repetitions:-->
                <mid:Attribute>
                    <mid:Name>?</mid:Name>
                    <mid:Value>?</mid:Value>
                </mid:Attribute>
              </mid:Attributes>
          </int:QueryBalanceReqHeader>
        </soapenv:Header>
        <soapenv:Body>
          <int:QueryBalanceReq>
              <!--Optional:-->
              <int:QueryBalanceReqBody/>
          </int:QueryBalanceReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    url = "#{url_service}/DirectTopupService/Topup/"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "#{host}/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryBalance",
      },
      :body => body
    )

    if (200...300).include?(request.code.to_i)
      return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
    end
  end

  def saldo_atual_zaptv
    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}/saldo"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}/saldo"
      api_key = parametro.api_key_zaptv_producao
    end

    url = "#{host}/saldo?code=#{STORE_ID_ZAP_PARCEIRO}"
    res = HTTParty.get(
      url, 
      headers: {
        "apikey" => api_key,
        "Content-Type" => "application/json"
      }
    )

    if (200..300).include?(res.code)
      return JSON.parse(res.body)["saldo"]
    else
      return 0
    end
  end

  def saldo_atual
    return this.send("saldo_atual_#{self.slug.downcase}")
  rescue Exception => err
    Rails.logger.info "::::#{err.message}::::"
  end
end
