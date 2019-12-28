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

  def self.fazer_venda(params, usuario, slug_parceiro)
    slug_parceiro = slug_parceiro.downcase.strip
    self.send("venda_#{slug_parceiro}", params, usuario)
  end

  def request_id
    self.response_get.scan(/RequestId.*?RequestId>/).first.scan(/\d/).join("") rescue ""
  end

  def status_movicel
    require 'openssl'

    #producao
    agent_key = "3958CFE4F3A8DB09B76B9C0D26A19F6D69E1F6DC3BC5779EB84CB866DD939DF4"
    url_service = "https://ws.movicel.co.ao:10073"

    #homologacao
    # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    # url_service = "http://wsqa.movicel.co.ao:10071"

    user_id = "TivTechno"
    request_id = self.request_id

    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
    # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
    pass = pass.strip

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
         <soapenv:Header>
            <int:QueryTransactionReqHeader>
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
            </int:QueryTransactionReqHeader>
         </soapenv:Header>
         <soapenv:Body>
            <int:QueryTransactionReq>
               <!--Optional:-->
               <int:QueryTransactionReqBody>
                  <mid1:TransactionNumber>?</mid1:TransactionNumber>
               </int:QueryTransactionReqBody>
            </int:QueryTransactionReq>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    url = "#{url_service}/DirectTopupService/Topup/"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryTransaction',
      },
      :body => body
    )

    if (200...300).include?(request.code.to_i)
      # return request.body
      # return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
      return Nokogiri::XML(request.body).children.children.children.children.children.text rescue nil
    end
  end

  def self.venda_movicel(params, usuario)
    ActiveRecord::Base.transaction do
      parceiro = Partner.where("lower(slug) = 'movicel'").first
      valor = params[:valor].to_i

      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o telemovel" if params[:movicel_telefone].blank?
      raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?

      telefone = params[:movicel_telefone]

      require 'openssl'


      #producao
      agent_key = "3958CFE4F3A8DB09B76B9C0D26A19F6D69E1F6DC3BC5779EB84CB866DD939DF4"
      url_service = "https://ws.movicel.co.ao:10073"

      #homologacao
      # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
      # url_service = "http://wsqa.movicel.co.ao:10071"

      user_id = "TivTechno"
      msisdn = telefone
      request_id = Time.now.strftime("%d%m%Y%H%M%S")

      pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
      # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
      pass = pass.strip

      request_send = ""
      response_get = ""
      last_request = ""

      body = "
        <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
          <soapenv:Header>
           <int:ValidateTopupReqHeader>
              <mid:RequestId>#{request_id}</mid:RequestId>
              <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
              <mid:SourceSystem>#{user_id}</mid:SourceSystem>  
              <mid:Credentials>
                 <mid:User>#{user_id}</mid:User>
                 <mid:Password>#{pass}</mid:Password>
                 </mid:Credentials>
                 <!--Optional:--> 
              </int:ValidateTopupReqHeader>
          </soapenv:Header>
          <soapenv:Body>
              <int:ValidateTopupReq>
                 <!--Optional:-->
                 <int:ValidateTopupReqBody>
                    <mid1:Amount>#{valor}</mid1:Amount>
                    <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
                 </int:ValidateTopupReqBody>
              </int:ValidateTopupReq>
          </soapenv:Body>
        </soapenv:Envelope>
      "

      request_send += "=========[ValidateTopup]========"
      request_send += body
      request_send += "=========[ValidateTopup]========"

      url = "#{url_service}/DirectTopupService/Topup/"
      uri = URI.parse(URI.escape(url))
      request = HTTParty.post(uri, 
        :headers => {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup',
        },
        :body => body
      )

      response_get += "=========[ValidateTopup]========"
      response_get += request.body
      response_get += "=========[ValidateTopup]========"

      if (200...300).include?(request.code.to_i) && request.body.include?("200</ReturnCode>")

        body = "
          <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
            <soapenv:Header>
                <int:TopupReqHeader>
                   <mid:RequestId>#{request_id}</mid:RequestId>
                   <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
                   <!--Optional:-->
                   <mid:SourceSystem>#{user_id}</mid:SourceSystem>
                   <mid:Credentials>
                      <mid:User>#{user_id}</mid:User>
                      <mid:Password>#{pass}</mid:Password>
                   </mid:Credentials>
                   <!--Optional:-->        
                </int:TopupReqHeader>
            </soapenv:Header>
            <soapenv:Body>
                <int:TopupReq>
                   <!--Optional:-->
                   <int:TopupReqBody>
                      <mid1:Amount>#{valor}</mid1:Amount>
                      <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
                      <!--Optional:-->
                      <mid1:Type>Default</mid1:Type>
                   </int:TopupReqBody>
                </int:TopupReq>
            </soapenv:Body>
          </soapenv:Envelope>
        "

        request_send += "=========[Topup]========"
        request_send += body
        request_send += "=========[Topup]========"

        url = "#{url_service}/DirectTopupService/Topup/"
        uri = URI.parse(URI.escape(url))
        request = HTTParty.post(uri, 
          :headers => {
            'Content-Type' => 'text/xml;charset=UTF-8',
            'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup',
          },
          :body => body
        )
        
        response_get += "=========[Topup]========"
        response_get += request.body
        response_get += "=========[Topup]========"

        last_request = request.body
      end

      venda = Venda.create(agent_id: AGENTE_ID, value: valor, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)

      venda.store_id = usuario.sub_agente.store_id_parceiro
      venda.seller_id = usuario.sub_agente.seller_id_parceiro
      venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

      venda.request_send = request_send
      venda.response_get = response_get
      venda.status = last_request.scan(/ReturnCode.*?<\/ReturnCode/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue "3"
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

  def self.venda_unitel(params, usuario)
    ActiveRecord::Base.transaction do
      
      parceiro = Partner.where("lower(slug) = 'unitel'").first
      valor = params[:valor].to_i

      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Produto não selecionado" if params[:unitel_produto_id].blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o telemovel" if params[:unitel_telefone].blank?
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
