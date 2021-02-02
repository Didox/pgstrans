class Dstv
  require 'openssl'

  TRADUCAO_DADOS = {
    "DateOfBirh" => "Date Of Birh",
    "MgIndicator" => "Mg Indicator",
    "cellNumber" => "Número do Celular",
    "correspondence" => "Correspondência",
    "faxNumber" => "Número do Fax",
    "initials" => "Iniciais",
    "language" => "Idioma",
    "Customer Number" => "Número do Cliente",
    "salutation" => "Salutation",
    "status" => "Status",
    "surname" => "Sobrenome",
    "type" => "Tipo",
    "typeName" => "Descrição do Tipo",
    "afterDue121To150" => "After Due 121 To 150",
    "afterDue151To180" => "After Due 151 To 180",
    "afterDue180UpField" => "After Due 180 Up Field",
    "afterDue1To30Field" => "After Due 1 To 30 Field",
    "afterDue31To60Field" => "After Due 31 To 60 Field",
    "afterDue61To90Field" => "After Due 61 To 90 Field",
    "afterDue91To120Field" => "After Due 91 To 120 Field",
    "currency" => "Moeda",
    "currentAmount" => "Quantidade Atual",
    "defaultCurrencytotalBalance" => "Saldo Total na Moeda Padrão",
    "defaultCuurencyCode" => "Código da Moeda Padrão",
    "invoicePeriod" => "Período da Fatura",
    "isPrimary" => "É Primário?",
    "lastInvoiceAmount" => "Valor da Última Fatura",
    "lastInvoiceDate" => "Última Data da Fatura",
    "methodOfPayment" => "Método de Pagamento",
    "number" => "Número",
    "paymentDueDate" => "Data de Vencimento",
    "segmentation" => "Segmentação",
    "status" => "Status",
    "totalBalance" => "Saldo Total",
  }

  def self.produtos
    partner = Partner.where(slug: "DSTv").first
    Produto.produtos.where(partner_id: partner.id)
  end

  def self.produtos_ativos
    produtos = Dstv.produtos
    produtos = produtos.where("valor_compra_telemovel > 0 and produto_id_parceiro is not null and produto_id_parceiro <> ''").reorder("valor_compra_telemovel asc")
    produtos
  end

  def self.produtos_ativos_box_office
    produtos = Dstv.produtos
    produtos = produtos.where("(valor_compra_telemovel > 0 or produto_id_parceiro = 'BOXOFFICE') and produto_id_parceiro is not null and produto_id_parceiro <> ''").reorder("valor_compra_telemovel asc, nome_comercial asc")
    produtos
  end

  def self.importa_produtos(customer_number = nil, ip="?")
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language,customer_number_default = parametros
    customer_number = customer_number || customer_number_default
    partner = Partner.where(slug: "DSTv").first
   
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
         <soapenv:Header/>
         <soapenv:Body>
            <sel:GetAvailableProducts>
               <sel:dataSource>#{data_source}</sel:dataSource>
               <sel:customerNumber>#{customer_number}</sel:customerNumber>
               <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
               <sel:VendorCode>#{vendor_code}</sel:VendorCode>
               <sel:language>#{language}</sel:language>
               <sel:ipAddress>#{ip}</sel:ipAddress>
               <sel:interfaceType>?</sel:interfaceType>
            </sel:GetAvailableProducts>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    Rails.logger.info "=========================================="
    Rails.logger.info url_service
    Rails.logger.info "=========================================="
    Rails.logger.info body
    Rails.logger.info "=========================================="
    Rails.logger.info "GetAvailableProducts"
    Rails.logger.info "=========================================="

    request = fazer_request(url_service, body, "GetAvailableProducts")

    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="

    if (200...300).include?(request.code.to_i)
      if request.body.present?

        xml_doc = Nokogiri::XML(request.body)
        itens = xml_doc.child.children[0].children[0].children[0].children
        itens.each do |item|

          produto_id_parceiro = 0
          descricao = ""
          price = 0
          currency = ""
          item.children.each do |campo|
            if campo.name == "productCode"
              produto_id_parceiro = campo.content
            elsif campo.name == "currency"
              currency = campo.content
            elsif campo.name == "productDesc"
              descricao = campo.content
            elsif campo.name == "productPrice"
              price = campo.content.to_f
            end
          end

          if Produto.where(produto_id_parceiro: produto_id_parceiro, partner_id: partner.id).where("created_at BETWEEN ? AND ?", (Time.zone.now - 2.minutes), (Time.zone.now + 2.minutes)).count == 0
            produto = Produto.new
            produto.produto_id_parceiro = produto_id_parceiro
            produto.partner_id = partner.id
            produto.description = descricao
            produto.valor_compra_telemovel = price
            produto.valor_compra_site = price
            produto.valor_compra_pos = price
            produto.valor_compra_tef = price
            produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{currency}')").first.id rescue Moeda.where(simbolo: "Kz").first.id
            produto.status_produto = StatusProduto.where(nome: "Inativo").first
            produto.save!
          end
        end
      end
    else
      raise "API DSTV Não retornou 200, sem dados para atualização"
    end

    item = UltimaAtualizacaoProduto.where(partner_id: partner.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      UltimaAtualizacaoProduto.create(partner_id: partner.id)
    end
  end

  def self.consulta_saldo(ip="?")
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language,customer_number_default = parametros
    partner = Partner.where(slug: "DSTv").first
   
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetAgentDetails>
              <sel:agentDetailsRequest>
                  <sel1:dataSource>#{data_source}</sel1:dataSource>
                  <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
              </sel:agentDetailsRequest>
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <sel:language>#{language}</sel:language>
              <sel:ipAddress>#{ip}</sel:ipAddress>
              <sel:businessUnit>#{business_unit}</sel:businessUnit>
            </sel:GetAgentDetails>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    Rails.logger.info "=========================================="
    Rails.logger.info url_service
    Rails.logger.info "=========================================="
    Rails.logger.info body
    Rails.logger.info "=========================================="
    Rails.logger.info "GetAgentDetails"
    Rails.logger.info "=========================================="

    request = fazer_request(url_service, body, "GetAgentDetails")


    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="

    if (200...300).include?(request.code.to_i)
      if request.body.present?
        xml_doc = Nokogiri::XML(request.body)

        itens = xml_doc.child.children[0].children[0].children
        itens.each do |item|

          agent_balance = 0
          currency = ""
          agent_first_name = ""
          agent_last_name = ""
          audit_reference_number = ""
          device_id = ""
          device_description = ""

          item.children.each do |campo|
            if campo.name == "agentBalance"
              agent_balance = campo.content
            elsif campo.name == "currency"
              currency = campo.content
            elsif campo.name == "agentFirstName"
              agent_first_name = campo.content
            elsif campo.name == "agentLastName"
              agent_last_name = campo.content
            elsif campo.name == "AuditReferenceNumber"
              audit_reference_number = campo.content
            elsif campo.name == "DeviceCollection"
              device_id = campo.children[0].children[0].content rescue ""
              device_description = campo.children[0].children[1].content rescue ""
            end
          end

          if SaldoParceiroDstv.where(partner_id: partner.id).where("created_at BETWEEN ? AND ?", (Time.zone.now - 2.minutes), (Time.zone.now + 2.minutes)).count == 0
            saldo_dstv = SaldoParceiroDstv.new
            saldo_dstv.request = body
            saldo_dstv.partner_id = partner.id
            saldo_dstv.response = request.body
            saldo_dstv.saldo = agent_balance
            saldo_dstv.moeda = currency
            saldo_dstv.agent_first_name = agent_first_name
            saldo_dstv.agent_last_name = agent_last_name
            saldo_dstv.audit_reference_number = audit_reference_number
            saldo_dstv.device_id = device_id
            saldo_dstv.device_description = device_description
            saldo_dstv.save!
          end
        end
      end
    else
      raise "API DSTV Não retornou 200, sem dados para atualização"
    end

    item = SaldoParceiroDstv.where(partner_id: partner.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      SaldoParceiroDstv.create(partner_id: partner.id)
    end
  end

  def self.alteracao_plano_mensal_anual(produto_id_parceiro, customer_number, tipo_plano, ip, usuario_logado)
    raise "Selecione o produto" if produto_id_parceiro.blank?
    raise "Customer number não pode ser vazio" if customer_number.blank?
    raise "Tipo de plano não pode ser vazio" if tipo_plano.blank?
    produto = Dstv.produtos.where(produto_id_parceiro: produto_id_parceiro).first
    raise "Selecione um produto válido" if produto.blank?

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    sequencial = SequencialDstv.order("id desc").first
    if sequencial.blank?
      sequencial = SequencialDstv.new
      sequencial.numero = 1
    else
      sequencial.numero += 1
    end

    
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial.numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{produto.valor_compra_telemovel}</sel1:amount>
            <sel1:invoicePeriod>#{tipo_plano == "mensal" ? "1" : "12"}</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>Pagaso payment system (#{usuario_logado.nome})</sel1:paymentDescription>
            <sel1:methodofPayment>#{mop}</sel1:methodofPayment>
            <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
            <sel1:productCollection>
              <sel1:Product>
              <sel1:productUserkey>#{produto.produto_id_parceiro}</sel1:productUserkey>
              </sel1:Product>
            </sel1:productCollection>
            <sel1:baskedId>0</sel1:baskedId>
          </sel:agentPaymentRequest>
          <sel:VendorCode>#{vendor_code}</sel:VendorCode>
          <sel:language>#{language}</sel:language>
          <sel:ipAddress>#{ip}</sel:ipAddress>
          <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
        </sel:AgentSubmitPayment>
        </soapenv:Body>
      </soapenv:Envelope>
    "
    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial.numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise mensagem if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise "Pagamento não processado" if agent_submit_payment.blank?

    return agent_submit_payment_hash_parse(produto.description, produto.produto_id_parceiro, produto.valor_compra_telemovel, agent_submit_payment, request, body, customer_number, usuario_logado, nil, tipo_plano)
  end

  def self.agent_submit_payment_hash_parse(produtos, codigos, valor_total, agent_submit_payment, request, body, customer_number, usuario_logado, smartcard=nil, tipo_plano="mensal")
    agent_submit_payment_hash = {
      "produto" => produtos,
      "codigo" => codigos,
      "valor" => valor_total,
      "tipo_plano" => tipo_plano
    }

    agent_submit_payment_hash["receiptNumber"] = agent_submit_payment.children.select{|child| child.name == "receiptNumber"}.first.text
    agent_submit_payment_hash["transactionNumber"] = agent_submit_payment.children.select{|child| child.name == "transactionNumber"}.first.text
    agent_submit_payment_hash["status"] = agent_submit_payment.children.select{|child| child.name == "status"}.first.text
    agent_submit_payment_hash["transactionDateTime"] = agent_submit_payment.children.select{|child| child.name == "transactionDateTime"}.first.text
    agent_submit_payment_hash["errorMessage"] = agent_submit_payment.children.select{|child| child.name == "errorMessage"}.first.text
    agent_submit_payment_hash["AuditReferenceNumber"] = agent_submit_payment.children.select{|child| child.name == "AuditReferenceNumber"}.first.text

    raise agent_submit_payment_hash["errorMessage"] if agent_submit_payment_hash["errorMessage"].present?

    alteracoes_planos_dstv = AlteracoesPlanosDstv.new
    alteracoes_planos_dstv.request_body = request.body
    alteracoes_planos_dstv.response_body = body
    alteracoes_planos_dstv.tipo_plano = tipo_plano
    alteracoes_planos_dstv.customer_number = customer_number
    alteracoes_planos_dstv.smartcard = smartcard
    alteracoes_planos_dstv.usuario_id = usuario_logado.id
    alteracoes_planos_dstv.produto = agent_submit_payment_hash["produto"]
    alteracoes_planos_dstv.codigo = agent_submit_payment_hash["codigo"]
    alteracoes_planos_dstv.valor = agent_submit_payment_hash["valor"]
    alteracoes_planos_dstv.receipt_number = agent_submit_payment_hash["receiptNumber"]
    alteracoes_planos_dstv.transaction_number = agent_submit_payment_hash["transactionNumber"]
    alteracoes_planos_dstv.status = agent_submit_payment_hash["status"]
    alteracoes_planos_dstv.transaction_date_time = agent_submit_payment_hash["transactionDateTime"]
    alteracoes_planos_dstv.audit_reference_number = agent_submit_payment_hash["AuditReferenceNumber"]
    alteracoes_planos_dstv.save!

    return agent_submit_payment_hash
  end

  def self.altera_plano(customer_number, smartcard, produtos, ip, usuario_logado)
    raise "Selecione pelo menos um produto" if produtos.blank?
    raise "Customer number não pode ser vazio" if customer_number.blank?
    raise "Smartcard não pode ser vazio" if smartcard.blank?

    valor_total = 0
    produtos_api = ""
    produtos_enviados = []
    produtos.each do |produto_id|
      produto = Produto.find(produto_id)
      valor_total += produto.valor_compra_telemovel

      produtos_enviados << produto

      produtos_api += "<sel1:Product>";
      produtos_api += "<sel1:productUserkey>#{produto.produto_id_parceiro}</sel1:productUserkey>";
      produtos_api += "</sel1:Product>";
    end

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    sequencial = SequencialDstv.order("id desc").first
    if sequencial.blank?
      sequencial = SequencialDstv.new
      sequencial.numero = 1
    else
      sequencial.numero += 1
    end
    
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial.numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{valor_total}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>Pagaso payment system (#{usuario_logado.nome})</sel1:paymentDescription>
            <sel1:methodofPayment>#{mop}</sel1:methodofPayment>
            <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
            <sel1:productCollection>
              #{produtos_api}
            </sel1:productCollection>
            <sel1:baskedId>0</sel1:baskedId>
          </sel:agentPaymentRequest>
          <sel:VendorCode>#{vendor_code}</sel:VendorCode>
          <sel:language>#{language}</sel:language>
          <sel:ipAddress>#{ip}</sel:ipAddress>
          <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
        </sel:AgentSubmitPayment>
        </soapenv:Body>
      </soapenv:Envelope>
    "
    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial.numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise mensagem if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise "Pagamento não processado" if agent_submit_payment.blank?

    return agent_submit_payment_hash_parse(produtos_enviados.map{|produto| produto.description}.join(", "), produtos_enviados.map{|produto| produto.produto_id_parceiro}.join(", "), valor_total, agent_submit_payment, request, body, customer_number, usuario_logado, smartcard)
  end

  def self.informacoes_device_number(smartcard, ip)
    raise "Por favor digite o smartcard" if smartcard.blank?

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByDeviceNumber>
              <sel:dataSource>#{data_source}</sel:dataSource>
              <sel:deviceNumber>#{smartcard}</sel:deviceNumber>
              <sel:currencyCode>#{currency}</sel:currencyCode>
              <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <sel:language>#{language}</sel:language>
              <sel:ipAddress>#{ip}</sel:ipAddress>
              <sel:interfaceType>?</sel:interfaceType>
            </sel:GetCustomerDetailsByDeviceNumber>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, "GetCustomerDetailsByDeviceNumber")
    return informacoes_parse(request.body)
  end

  def self.informacoes_customer_number(customer_number, ip)
    raise "Por favor digite o customer number" if customer_number.blank?
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByCustomerNumber>
              <sel:dataSource>#{data_source}</sel:dataSource>
              <sel:customerNumber>#{customer_number}</sel:customerNumber>
              <sel:currencyCode>#{currency}</sel:currencyCode>
              <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <sel:language>#{language}</sel:language>
              <sel:ipAddress>#{ip}</sel:ipAddress>
              <sel:interfaceType>?</sel:interfaceType>
            </sel:GetCustomerDetailsByCustomerNumber>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, "GetCustomerDetailsByCustomerNumber")
    return informacoes_parse(request.body)
  end

  def self.consulta_fatura(smartcard, customer_number, ip)
    raise "Por favor digite o smartcard" if smartcard.blank?
    raise "Por favor digite o customer_number" if customer_number.blank?
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
          <sel:GetDueAmountandDate>
            <sel:dataSource>#{data_source}</sel:dataSource>
            <sel:customerNumber>#{customer_number}</sel:customerNumber>
            <sel:SCNumber>#{smartcard}</sel:SCNumber>
            <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
            <sel:VendorCode>#{vendor_code}</sel:VendorCode>
            <sel:language>#{language}</sel:language>
            <sel:ipAddress>#{ip}</sel:ipAddress>
            <sel:interfaceType>?</sel:interfaceType>
          </sel:GetDueAmountandDate>
        </soapenv:Body>
      </soapenv:Envelope>
    "
    request = fazer_request(url_service, body, "GetDueAmountandDate")

    xml_doc = Nokogiri::XML(request.body)

    get_due_amountand_date = xml_doc.child.child.child.children rescue nil
    if get_due_amountand_date.blank?
      mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
      raise mensagem if mensagem.present?
    end

    detail_hash = {}

    detail_hash["AuditReferenceNumber"] = get_due_amountand_date.children.select{|child| child.name == "AuditReferenceNumber"}.first.text
    detail_hash["currency"] = get_due_amountand_date.children.select{|child| child.name == "currency"}.first.text
    detail_hash["defaultCurrencyDueAmount"] = get_due_amountand_date.children.select{|child| child.name == "defaultCurrencyDueAmount"}.first.text
    detail_hash["defaultCuurencyCode"] = get_due_amountand_date.children.select{|child| child.name == "defaultCuurencyCode"}.first.text
    detail_hash["dueAmount"] = get_due_amountand_date.children.select{|child| child.name == "dueAmount"}.first.text
    detail_hash["dueDate"] = get_due_amountand_date.children.select{|child| child.name == "dueDate"}.first.text

    return detail_hash
  end

  def self.pagar_fatura(customer_number, valor, ip, usuario_logado)
    raise "Por favor digite o customer_number" if customer_number.blank?
    raise "Por favor digite o valor" if valor.blank?
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    sequencial = SequencialDstv.order("id desc").first
    if sequencial.blank?
      sequencial = SequencialDstv.new
      sequencial.numero = 1
    else
      sequencial.numero += 1
    end
    body = "
    <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial.numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{valor}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>Pagaso payment system (#{usuario_logado.nome})</sel1:paymentDescription>
            <sel1:methodofPayment>#{mop}</sel1:methodofPayment>
            <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
            <sel1:productCollection>
              <sel1:Product>
                <sel1:productUserkey></sel1:productUserkey>
              </sel1:Product>
            </sel1:productCollection>
            <sel1:baskedId>0</sel1:baskedId>
          </sel:agentPaymentRequest>
          <sel:VendorCode>#{vendor_code}</sel:VendorCode>
          <sel:language>#{language}</sel:language>
          <sel:ipAddress>#{ip}</sel:ipAddress>
          <sel:BusinessUnit>#{business_unit}</sel:BusinessUnit>
        </sel:AgentSubmitPayment>
        </soapenv:Body>
      </soapenv:Envelope>
    "
    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial.numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise mensagem if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise "Pagamento não processado" if agent_submit_payment.blank?

    agent_submit_payment_hash = {}

    agent_submit_payment_hash["receiptNumber"] = agent_submit_payment.children.select{|child| child.name == "receiptNumber"}.first.text
    agent_submit_payment_hash["transactionNumber"] = agent_submit_payment.children.select{|child| child.name == "transactionNumber"}.first.text
    agent_submit_payment_hash["status"] = agent_submit_payment.children.select{|child| child.name == "status"}.first.text
    agent_submit_payment_hash["transactionDateTime"] = agent_submit_payment.children.select{|child| child.name == "transactionDateTime"}.first.text
    agent_submit_payment_hash["errorMessage"] = agent_submit_payment.children.select{|child| child.name == "errorMessage"}.first.text
    agent_submit_payment_hash["AuditReferenceNumber"] = agent_submit_payment.children.select{|child| child.name == "AuditReferenceNumber"}.first.text

    pagamentos_faturas_dstv = PagamentosFaturasDstv.new
    pagamentos_faturas_dstv.request_body = request.body
    pagamentos_faturas_dstv.response_body = body
    pagamentos_faturas_dstv.customer_number = customer_number
    pagamentos_faturas_dstv.valor = valor
    pagamentos_faturas_dstv.usuario_id = usuario_logado.id
    pagamentos_faturas_dstv.receipt_number = agent_submit_payment_hash["receiptNumber"]
    pagamentos_faturas_dstv.transaction_number = agent_submit_payment_hash["transactionNumber"]
    pagamentos_faturas_dstv.status = agent_submit_payment_hash["status"]
    pagamentos_faturas_dstv.transaction_date_time = agent_submit_payment_hash["transactionDateTime"]
    pagamentos_faturas_dstv.audit_reference_number = agent_submit_payment_hash["AuditReferenceNumber"]
    pagamentos_faturas_dstv.save!

    raise agent_submit_payment_hash["errorMessage"] if agent_submit_payment_hash["errorMessage"].present?

    return agent_submit_payment_hash
  end

  def self.parametros
    parceiro = Partner.where("lower(slug) = 'dstv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise "Parâmetros não localizados" if parametro.blank?
    raise "Parceiro não localizado" if parceiro.blank?

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
      business_unit = parametro.business_unit_desenvolvimento
      language = parametro.language_desenvolvimento
      customer_number_default = parametro.customer_number_desenvolvimento
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
      business_unit = parametro.business_unit_producao
      language = parametro.language_producao
      customer_number_default = parametro.customer_number_producao
    end

    [parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language,customer_number_default]
  end

  def self.fazer_request(url_service, body, resource)
    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/#{resource}",
      },
      :body => body
    )

    Rails.logger.info "=========================================="
    Rails.logger.info body
    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="

    return request
  end

  def self.informacoes_parse(body)
    xml_doc = Nokogiri::XML(body)

    customer_detail_hash = {}
    customer_details = xml_doc.child.child.child.child.children.select{|child| child.name == "customerDetails"}.first rescue nil
    accounts_xml = xml_doc.child.child.child.child.children.select{|child| child.name == "accounts"}.first rescue nil

    if customer_details.blank? || accounts_xml.blank?
      mensagem = body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
      raise mensagem if mensagem.present?
    end

    if customer_details
      customer_details.children.each do |detail|
        customer_detail_hash["#{detail.name}"] = detail.text
      end
    end

    accounts = []
    if accounts_xml
      accounts_xml.children.each do |account_xml|
        account = {}

        account_xml.children.each do |account_field_xml|
          account["#{account_field_xml.name}"] = account_field_xml.text
        end
        accounts << account
      end
    end

    return {
      customer_detail: customer_detail_hash,
      accounts: accounts
    }
  end
end