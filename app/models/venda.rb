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
    ReturnCodeApi.where(return_code: self.status, sucesso: true, partner_id: self.partner_id).count > 0
  end

  def self.fazer_venda(params, usuario, slug_parceiro)
    slug_parceiro = slug_parceiro.downcase.strip
    self.send("venda_#{slug_parceiro}", params, usuario)
  end

  def request_id
    if super.present?
      return super
    end

    self.response_get.scan(/RequestId.*?RequestId>/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue ""
  end

  def status_movicel
    return if self.partner.name.downcase != "movicel"

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
      return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
      # return "#{request_id} - #{Nokogiri::XML(request.body).children.children.children.children.children.text}" rescue nil
    end
  end

  def carregamento_venda_zaptv
    host = "http://10.151.59.196"
    url = "#{host}/ao/echarge/pagaso/dev/carregamento/#{self.request_id}"
    begin
      if self.request_id.present?
        res = HTTParty.get(
          url, 
          headers: {
            "apikey" => "b65298a499c84224d442c6a680d14b8e",
            "Content-Type" => "application/json"
          }
        )

        if (200..300).include?(res.code)
          self.status = "7000"
          self.save!
          return "sucesso"
        else
          return "Delete in (#{url}) - #{res.body}"
        end
      end

      return "Código de operação ZAPTV não encontrado"
    rescue Exception => err
      return "GET in (#{url}) - #{err.message}"
    end
  end

  def reverter_venda_zaptv
    host = "http://10.151.59.196"
    url = "#{host}/ao/echarge/pagaso/dev/carregamento/#{self.request_id}"
    begin
      if self.request_id.present?
        res = HTTParty.delete(
          url, 
          headers: {
            "apikey" => "b65298a499c84224d442c6a680d14b8e",
            "Content-Type" => "application/json"
          }
        )

        if (200..300).include?(res.code)
          self.status = "7000"
          self.save!
          return "sucesso"
        else
          return "Delete in (#{url}) - #{res.body}"
        end
      end

      return "Código de operação ZAPTV não encontrado"
    rescue Exception => err
      return "Delete in (#{url}) - #{err.message}"
    end
  end

  def self.venda_zaptv(params, usuario)
    ActiveRecord::Base.transaction do
      parceiro = Partner.where("lower(slug) = 'zaptv'").first
      valor = params[:valor].to_i
      parametro = Parametro.where(partner_id: parceiro.id).first

      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Parâmetros não localizados" if parametro.blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o telemovel" if params[:zaptv_cartao].blank?
      raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?

      telefone = params[:zaptv_cartao]
      request_id = Time.now.strftime("%d%m%Y%H%M%S")

      if Rails.env == "development"
        host = parametro.url_integracao_desenvolvimento
        api_key = parametro.api_key_zaptv_desenvolvimento
      else
        host = parametro.url_integracao_producao
        api_key = parametro.api_key_zaptv_producao
      end

      raise "Produto não selecionado" if params[:zaptv_produto_id].blank?
      product_id = params[:zaptv_produto_id].split("-").first

      body_send = {
        :price => params[:valor].to_f, 
        :product_code => product_id, #produto importado zap
        :product_quantity => 1, 
        :source_reference => request_id, #meu código 
        :zappi => telefone #Iremos receber este numero
      }.to_json

      res = HTTParty.post(
        "#{host}/ao/echarge/pagaso/dev/carregamento", 
        headers: {
          "apikey" => api_key,
          "Content-Type" => "application/json"
        },
        :body => body_send,
      )

      venda = Venda.create(agent_id: AGENTE_ID, value: valor, request_id: request_id, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)

      venda.store_id = usuario.sub_agente.store_id_parceiro
      venda.seller_id = usuario.sub_agente.seller_id_parceiro
      venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

      venda.request_send = body_send
      venda.response_get = res.body

      begin
        venda.status = JSON.parse(res.body)["status_code"]
      rescue;end
      venda.status ||= res.code
      venda.save!

      if venda.sucesso?
        cc = ContaCorrente.where(usuario_id: usuario.id).first
        if cc.blank?
          banco = Banco.first
          iban = ""
        else
          iban = cc.iban
          banco = cc.banco
        end

        lancamento = Lancamento.where(nome: "Compra de crédito").first
        lancamento = Lancamento.first if lancamento.blank?

        ContaCorrente.create!(
          usuario: usuario,
          valor: "-#{valor}",
          observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
          lancamento_id: lancamento.id,
          banco_id: banco.id,
          partner_id: parceiro.id,
          iban: iban
        )
      end

      return venda
    end
  end

  def self.venda_movicel(params, usuario)
    ActiveRecord::Base.transaction do
      parceiro = Partner.where("lower(slug) = 'movicel'").first
      valor = params[:valor].to_i
      parametro = Parametro.where(partner_id: parceiro.id).first

      raise "Parâmetros não localizados" if parametro.blank?
      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o telemovel" if params[:movicel_telefone].blank?
      raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?

      telefone = params[:movicel_telefone]

      require 'openssl'

      if Rails.env == "development"
        url_service = parametro.url_integracao_desenvolvimento
        agent_key = parametro.agent_key_movicel_desenvolvimento
        user_id = parametro.user_id_movicel_desenvolvimento
      else
        url_service = parametro.url_integracao_producao
        agent_key = parametro.agent_key_movicel_producao
        user_id = parametro.user_id_movicel_producao
      end

      #producao

      #homologacao
      # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
      # url_service = "http://wsqa.movicel.co.ao:10071"

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

      venda = Venda.create(agent_id: AGENTE_ID, value: valor, request_id: request_id, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)

      venda.store_id = usuario.sub_agente.store_id_parceiro
      venda.seller_id = usuario.sub_agente.seller_id_parceiro
      venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

      venda.request_send = request_send
      venda.response_get = response_get
      venda.status = last_request.scan(/ReturnCode.*?<\/ReturnCode/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue "3"
      venda.save!

      if venda.sucesso?
        cc = ContaCorrente.where(usuario_id: usuario.id).first
        if cc.blank?
          banco = Banco.first
          iban = ""
        else
          iban = cc.iban
          banco = cc.banco
        end

        lancamento = Lancamento.where(nome: "Compra de crédito").first
        lancamento = Lancamento.first if lancamento.blank?

        ContaCorrente.create!(
          usuario: usuario,
          valor: "-#{valor}",
          observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
          lancamento_id: lancamento.id,
          banco_id: banco.id,
          partner_id: parceiro.id,
          iban: iban
        )
      end

      return venda
    end
  end

  def status_dstv
    return if self.partner.name.downcase != "dstv"
    
    #TODO fazer
    return 0
  end

  def self.venda_dstv(params, usuario)
    ActiveRecord::Base.transaction do
      parceiro = Partner.where("lower(slug) = 'dstv'").first
      valor = params[:valor].to_i
      parametro = Parametro.where(partner_id: parceiro.id).first

      raise "Parâmetros não localizados" if parametro.blank?
      raise "Saldo insuficiente para recarga" if usuario.saldo < valor
      raise "Parceiro não localizado" if parceiro.blank?
      raise "Selecione o valor" if params[:valor].blank?
      raise "Digite o Nº SmartCard" if params[:dstv_smart_card].blank?
      raise "Talão p/SMS" if params[:talao_sms].blank?
      raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?
      raise "Produto não selecionado" if params[:dstv_produto_id].blank?

      product_id = params[:dstv_produto_id].split("-").first

      require 'openssl'

      transaction_number = (Venda.order("id desc").first.id + 1)

      if Rails.env == "development"
        url_service = parametro.url_integracao_desenvolvimento
        data_source = parametro.data_source_dstv_desenvolvimento
        payment_vendor_code = parametro.payment_vendor_code_dstv_desenvolvimento
        vendor_code = parametro.vendor_code_dstv_desenvolvimento
        agent_account = parametro.agent_account_dstv_desenvolvimento
        currency = parametro.currency_dstv_desenvolvimento
        product_user_key = parametro.product_user_key_dstv_desenvolvimento
        mop = parametro.mop_dstv_desenvolvimento # mop = "CASH, MOBILE or ATM "
        agent_number = parametro.agent_number_dstv_desenvolvimento #122434345
      else
        url_service = parametro.url_integracao_producao
        data_source = parametro.data_source_dstv_producao
        payment_vendor_code = parametro.payment_vendor_code_dstv_producao
        vendor_code = parametro.vendor_code_dstv_producao
        agent_account = parametro.agent_account_dstv_producao
        currency = parametro.currency_dstv_producao
        product_user_key = parametro.product_user_key_dstv_producao
        mop = parametro.mop_dstv_producao # mop = "CASH, MOBILE or ATM "
        agent_number = parametro.agent_number_dstv_producao #122434345
      end

      request_send = ""
      response_get = ""
      last_request = ""

      body = "
        <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
           <soapenv:Header/>
           <soapenv:Body>
              <sel:AgentSubmitPayment>
                 <!--Optional:-->
                 <sel:agentPaymentRequest>
                    <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
                    <sel1:transactionNumber>#{transaction_number}</sel1:transactionNumber>
                    <sel1:dataSource>#{data_source}</sel1:dataSource>
                    <sel1:customerNumber>#{params[:dstv_smart_card]}</sel1:customerNumber>
                    <sel1:amount>#{params[:valor]}</sel1:amount>
                    <sel1:invoicePeriod>12</sel1:invoicePeriod>
                    <sel1:currency>AOA</sel1:currency>
                    <sel1:paymentDescription>?</sel1:paymentDescription>
                    <sel1:methodofPayment>CASH</sel1:methodofPayment>
                    <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
                    <sel1:productCollection>
                       <!--Zero or more repetitions:-->
                       <sel1:Product>
                          <!--Optional:-->
                          <sel1:productUserkey>#{product_id}</sel1:productUserkey>
                       </sel1:Product>
                    </sel1:productCollection>
                    <!--Optional:-->
                    <sel1:baskedId>0</sel1:baskedId>
                 </sel:agentPaymentRequest>
                 <!--Optional:-->
                 <sel:VendorCode>#{vendor_code}</sel:VendorCode>
                 <!--Optional:-->
                 <sel:language>PT</sel:language>
                 <!--Optional:-->
                 <sel:ipAddress>?</sel:ipAddress>
                 <!--Optional:-->
                 <sel:businessUnit>?</sel:businessUnit>
              </sel:AgentSubmitPayment>
           </soapenv:Body>
        </soapenv:Envelope>
      "

      request_send += "=========[SubmitPaymentBySmartCard]========"
      request_send += body
      request_send += "=========[SubmitPaymentBySmartCard]========"

      url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
      uri = URI.parse(URI.escape(url))
      request = HTTParty.post(uri, 
        :headers => {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/AgentSubmitPayment",
        },
        :body => body
      )
      
      response_get += "=========[SubmitPaymentBySmartCard]========"
      response_get += request.body
      response_get += "=========[SubmitPaymentBySmartCard]========"

      last_request = request.body
      
      venda = Venda.create(agent_id: AGENTE_ID, value: valor, request_id: transaction_number, client_msisdn: params[:dstv_smart_card], usuario_id: usuario.id, partner_id: parceiro.id)

      venda.store_id = usuario.sub_agente.store_id_parceiro
      venda.seller_id = usuario.sub_agente.seller_id_parceiro
      venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

      venda.request_send = request_send
      venda.response_get = response_get
      venda.status = last_request.scan(/receiptNumber.*?<\/receiptNumber/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue "3"

=begin
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
   <s:Body>
      <AgentSubmitPaymentResponse xmlns="http://services.multichoice.co.za/SelfCare">
         <AgentSubmitPaymentResult xmlns:a="http://datacontracts.multichoice.co.za/SelfCare" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
            <a:receiptNumber>3025716</a:receiptNumber>
            <a:transactionNumber>2</a:transactionNumber>
            <a:status>true</a:status>
            <a:transactionDateTime>2020-02-21T11:32:24.7167378+00:00</a:transactionDateTime>
            <a:errorMessage/>
            <a:AuditReferenceNumber>cc1741df-3818-40c5-9fda-a9ebb14b7692</a:AuditReferenceNumber>
         </AgentSubmitPaymentResult>
      </AgentSubmitPaymentResponse>
   </s:Body>
</s:Envelope>
=end
      venda.save!

      if venda.sucesso?
        ContaCorrente.create!(
          usuario: usuario,
          valor: "-#{valor}",
          observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
          lancamento: Lancamento.where(nome: "Compra de crédito"),
          banco: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
          partner_id: parceiro.id,
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
      parametro = Parametro.where(partner_id: parceiro.id).first

      raise "Parâmetros não localizados" if parametro.blank?
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

      sequence = UnitelSequence.order("id desc").first
      if sequence.blank?
        sequence_id = 1
      else
        sequence_id = sequence.sequence_id + 1
      end
      
      if Rails.env == "development"
        make_sale_endpoint = "#{parametro.url_integracao_desenvolvimento}/spgw/V2/makeSale"
      else
        make_sale_endpoint = "#{parametro.url_integracao_producao}/spgw/V2/makeSale"
      end

      # ./chaves/unitel_recarga.sh '7' '9' '114250' '' '' '' '500' '244998524570' 'https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale'
      dados_envio = "./chaves/unitel_recarga.sh '#{sequence_id}' '#{venda.product_id}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor}' '#{venda.client_msisdn}' '#{make_sale_endpoint}'"

      retorno = `./chaves/unitel_recarga.sh '#{sequence_id}' '#{venda.product_id}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor}' '#{venda.client_msisdn}' '#{make_sale_endpoint}'`
      venda.request_send, venda.response_get = retorno.split(" --- ")
      venda.request_send = "#{venda.request_send} ========== #{dados_envio}"
      venda.status = venda.response_get_parse["statusCode"] rescue "3"
      venda.save!

      UnitelSequence.create(sequence_id: sequence_id, venda_id: venda.id)

      if venda.sucesso?
        ContaCorrente.create!(
          usuario: usuario,
          valor: "-#{valor}",
          observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
          lancamento: Lancamento.where(nome: "Compra de crédito"),
          partner_id: parceiro.id,
          banco: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
          iban: ContaCorrente.where(usuario_id: usuario.id).first.iban
        )
      end

      return venda
    end
  end
end
