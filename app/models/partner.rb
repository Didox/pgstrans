class Partner < ApplicationRecord
  has_many :return_code_api
  validates :name, presence: true, uniqueness: true
  belongs_to :status_parceiro
  default_scope { order(order: :asc) }

  def importa_produtos!
    return if self.slug.downcase != "zaptv"

    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first
    host = Rails.env == "development" ? parametro.url_integracao_desenvolvimento : parametro.url_integracao_producao

    res = HTTParty.get(
      "#{host}/ao/echarge/pagaso/dev/portfolio/menu", 
      headers: {
        apikey: "b65298a499c84224d442c6a680d14b8e"
      }
    )

    if (200...300).include?(res.code)
      partner = Partner.where(slug: "ZAPTv").first
      dados = JSON.parse(res.body)
      dados["Products"].each do |p_hash|
        produtos = Produto.where(produto_id_parceiro: p_hash["code"], partner_id: partner.id)
        if produtos.count == 0
          produto = Produto.new
          produto.produto_id_parceiro = p_hash["code"]
          produto.partner_id = partner.id
        else
          produto = produtos.first
        end

        produto.description = p_hash["description"]
        produto.valor_minimo_venda_site = p_hash["price"]
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
  end

  def importa_dados!
    return if self.slug.downcase != "zaptv"

    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first
    host = Rails.env == "development" ? parametro.url_integracao_desenvolvimento : parametro.url_integracao_producao

    ###### Entender se realmente não precisamos passar este id
    # partner.store_id_parceiro # "115356"
    ############################################################
    day = Time.zone.now
    ((Time.zone.now - 20.days) .. Time.zone.now.day).each do |d|
      day = day.change(day: d) 
      url = "#{host}/ao/echarge/pagaso/dev/carregamento/report/#{day.strftime("%Y-%m-%d")}"

      Rails.logger.info ":::: (#{url}) ::::"

      next if RelatorioConciliacaoZaptv.where(url: url).count > 0

      res = HTTParty.get(
        url, 
        headers: {
          "apikey" => "b65298a499c84224d442c6a680d14b8e",
          "Content-Type" => "application/json"
        }
      )

      if (200..300).include?(res.code)
        dados = JSON.parse(res.body)
        dados.each do |dado|
          rel = RelatorioConciliacaoZaptv.create(
            partner_id: partner.id,
            url: url,
            operation_code: dado["operation_code"],
            source_reference: dado["source_reference"],
            product_code: dado["product_code"],
            quantity: dado["quantity"],
            date_time: dado["datetime"],
            type_data: dado["type"],
            total_price: dado["total_price"],
            status: dado["status"],
            unit_price: dado["unit_price"]
          )

          Rails.logger.info ":::: Rel criado (#{rel.id}) ::::"
        end
      else
        Rails.logger.info ":::: Não encontrado (#{res.body}) ::::"
      end
    end
  end

  def saldo_atual
    if self.slug.downcase == "movicel"
      require 'openssl'

      #producao
      agent_key = "3958CFE4F3A8DB09B76B9C0D26A19F6D69E1F6DC3BC5779EB84CB866DD939DF4"
      url_service = "https://ws.movicel.co.ao:10073"

      #homologacao
      # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
      # url_service = "http://wsqa.movicel.co.ao:10071"

      user_id = "TivTechno"
      request_id = Time.now.strftime("%d%m%Y%H%M%S")

      pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
      # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
      pass = pass.strip

      body = "
        <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\">
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
          'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryBalance',
        },
        :body => body
      )

      if (200...300).include?(request.code.to_i)
        return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
      end
    elsif self.slug.downcase == "zaptv"
      parceiro = Partner.where("lower(slug) = 'zaptv'").first
      parametro = Parametro.where(partner_id: parceiro.id).first
      host = Rails.env == "development" ? parametro.url_integracao_desenvolvimento : parametro.url_integracao_producao

      store_id_parceiro = "115356"
      url = "#{host}/ao/echarge/pagaso/dev/saldo?code=#{store_id_parceiro}"
      res = HTTParty.get(
        url, 
        headers: {
          "apikey" => "b65298a499c84224d442c6a680d14b8e",
          "Content-Type" => "application/json"
        }
      )

      if (200..300).include?(res.code)
        return JSON.parse(res.body)["saldo"]
      else
        return 0
      end
    end
  
  rescue Exception => err
    Rails.logger.info "::::#{err.message}::::"
  end
end
