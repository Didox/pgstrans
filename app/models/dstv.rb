class Dstv
  require 'openssl'

  TRADUCAO_DADOS_CLIENTE = {
    "initials" => "Primeiro Nome",
    "surname" => "Sobrenome",
    "cellNumber" => "Número do Celular",
    "emailAddress" => "Email",
    "language" => "Idioma",
    "number" => "Número do Cliente",
    "status" => "Status",
  }

  TRADUCAO_DADOS_CONTAS = {
    "currency" => "Moeda",
    "currentAmount" => "Quantidade Atual",
    "defaultCurrencytotalBalance" => "Saldo Total na Moeda Padrão",
    "invoicePeriod" => "Período da Fatura",
    "lastInvoiceAmount" => "Valor da Última Fatura",
    "lastInvoiceDate" => "Última Data da Fatura",
    "paymentDueDate" => "Data de Vencimento",
    "totalBalance" => "Saldo Total",
    "type" => "Tipo",
  }

  def self.produtos
    partner = Partner.dstv
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

  def self.busca_nome(tipo_numero, remote_ip)
    tipo, numero = tipo_numero.split("-")
    
    if tipo.downcase == "smartcard"
      info = Dstv.informacoes_device_number(numero, remote_ip)
    else
      info = Dstv.informacoes_customer_number(numero, remote_ip)
    end

    dados_cliente = {}
    Dstv::TRADUCAO_DADOS_CLIENTE.each do |k, v|
      info[:customer_detail].each do |key, val|
        if key == k
          key_translate = Dstv::TRADUCAO_DADOS_CLIENTE[key].parameterize.gsub("-", "_")
          if val.present? && key_translate.present?
            dados_cliente[key_translate] = val
          end
        end
      end
    end

    nome = "#{dados_cliente["primeiro_nome"]} #{dados_cliente["sobrenome"]}" rescue nil

    #return "Cliente não encontrado na operadora" if nome.blank?
    return " " if nome.blank?
    
    return nome
  end

  def self.importa_produtos(customer_number = nil, ip="?")
    customer_number = customer_number.to_s.strip
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language,customer_number_default = parametros
    customer_number = customer_number || customer_number_default
    partner = Partner.dstv
    customer_number = 0 if customer_number.blank?
   
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

          if Produto.where(produto_id_parceiro: produto_id_parceiro, partner_id: partner.id).where("created_at BETWEEN ? AND ?", SqlDate.sql_parse((Time.zone.now - 2.minutes)), SqlDate.sql_parse((Time.zone.now + 2.minutes))).count == 0
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
      raise PagasoError.new("API DSTV Não retornou 200, sem dados para atualização")
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
    partner = Partner.dstv
   
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

          if SaldoParceiroDstv.where(partner_id: partner.id).where("created_at BETWEEN ? AND ?", SqlDate.sql_parse((Time.zone.now - 2.minutes)), SqlDate.sql_parse((Time.zone.now + 2.minutes))).count == 0
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
      raise PagasoError.new("API DSTV Não retornou 200, sem dados para atualização")
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
    raise PagasoError.new("Selecione o produto") if produto_id_parceiro.blank?
    raise PagasoError.new("Customer number não pode ser vazio") if customer_number.blank?
    raise PagasoError.new("Tipo de plano não pode ser vazio") if tipo_plano.blank?
    produto = Dstv.produtos.where(produto_id_parceiro: produto_id_parceiro).first
    raise PagasoError.new("Selecione um produto válido") if produto.blank?

    customer_number = customer_number.strip

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    sequencial_numero = Time.now.to_i

    raise PagasoError.new("Valor da fatura é insuficiente para pagamento") if produto.valor_compra_telemovel.to_f < 0.1
    raise PagasoError.new("Saldo insuficiente para realizar a operação, seu saldo atual é de KZ #{usuario_logado.saldo.round(2)}") if usuario_logado.saldo < produto.valor_compra_telemovel.to_f
    
    paymentDescription = "Pagaso - #{usuario_logado.nome}".truncate(49)
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial_numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{produto.valor_compra_telemovel}</sel1:amount>
            <sel1:invoicePeriod>#{tipo_plano == "mensal" ? "1" : "12"}</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>#{paymentDescription}</sel1:paymentDescription>
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

    raise PagasoError.new("Transação duplicada") if SequencialDstv.where(response_body: body).count > 0

    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial_numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    mensagem = xml_doc.child.child.child.children.select{|child| child.name == "faultstring"}.first.text rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise PagasoError.new("Pagamento não processado") if agent_submit_payment.blank?

    return agent_submit_payment_hash_parse(produto.description, produto.produto_id_parceiro, produto.valor_compra_telemovel, agent_submit_payment, request, body, customer_number, usuario_logado, nil, tipo_plano, Lancamento::ALTERACAO_PLANO)
  end

  def self.agent_submit_payment_hash_parse(produtos, codigos, valor_total, agent_submit_payment, request, body, customer_number, usuario_logado, smartcard=nil, tipo_plano="mensal", lancamento = Lancamento::ALTERACAO_PLANO)
    agent_submit_payment_hash = {
      "produto" => produtos,
      "codigo" => codigos,
      "valor" => valor_total,
      "tipo_plano" => tipo_plano
    }

    agent_submit_payment_hash["errorMessage"] = agent_submit_payment.children.select{|child| child.name == "errorMessage"}.first.text rescue ""
    agent_submit_payment_hash["errorMessage"] ||= agent_submit_payment.children.select{|child| child.name == "Message"}.first.text rescue ""
    
    raise PagasoError.new(ErroAmigavel.traducao(agent_submit_payment_hash["errorMessage"])) if agent_submit_payment_hash["errorMessage"].present?

    agent_submit_payment_hash["receiptNumber"] = agent_submit_payment.children.select{|child| child.name == "receiptNumber"}.first.text rescue ""
    agent_submit_payment_hash["transactionNumber"] = agent_submit_payment.children.select{|child| child.name == "transactionNumber"}.first.text rescue ""
    agent_submit_payment_hash["status"] = agent_submit_payment.children.select{|child| child.name == "status"}.first.text rescue ""
    agent_submit_payment_hash["transactionDateTime"] = agent_submit_payment.children.select{|child| child.name == "transactionDateTime"}.first.text rescue ""
    agent_submit_payment_hash["AuditReferenceNumber"] = agent_submit_payment.children.select{|child| child.name == "AuditReferenceNumber"}.first.text rescue ""

    alteracoes_planos_dstv = Venda.new
    alteracoes_planos_dstv.request_send = request.body
    alteracoes_planos_dstv.response_get = body
    alteracoes_planos_dstv.tipo_plano = tipo_plano
    alteracoes_planos_dstv.customer_number = customer_number
    alteracoes_planos_dstv.smartcard = smartcard
    alteracoes_planos_dstv.usuario_id = usuario_logado.id
    alteracoes_planos_dstv.responsavel = usuario_logado
    alteracoes_planos_dstv.product_nome = agent_submit_payment_hash["produto"]
    alteracoes_planos_dstv.codigos_produto = agent_submit_payment_hash["codigo"]
    alteracoes_planos_dstv.partner_id = Partner.dstv.id

    desconto_aplicado, valor_original, valor = Venda.desconto_venda(usuario_logado, Partner.dstv, agent_submit_payment_hash["valor"])
    alteracoes_planos_dstv.desconto_aplicado = desconto_aplicado
    alteracoes_planos_dstv.valor_original = valor_original
    alteracoes_planos_dstv.value = valor

    alteracoes_planos_dstv.receipt_number = agent_submit_payment_hash["receiptNumber"]
    alteracoes_planos_dstv.transaction_number = agent_submit_payment_hash["transactionNumber"]
    alteracoes_planos_dstv.status = agent_submit_payment_hash["status"]
    alteracoes_planos_dstv.transaction_date_time = agent_submit_payment_hash["transactionDateTime"]
    alteracoes_planos_dstv.audit_reference_number = agent_submit_payment_hash["AuditReferenceNumber"]
    alteracoes_planos_dstv.lancamento = Lancamento.where(nome: lancamento).first || Lancamento.first
    alteracoes_planos_dstv.save!
    
    conta_corrente_retirada = ContaCorrente.new
    conta_corrente_retirada.valor = "-#{alteracoes_planos_dstv.value.to_f.abs}"
    conta_corrente_retirada.usuario = usuario_logado
    conta_corrente_retirada.responsavel = usuario_logado
    conta_corrente_retirada.lancamento = Lancamento.where(nome: lancamento).first || Lancamento.first
    conta_corrente_retirada.responsavel_aprovacao_id = usuario_logado.id
    conta_corrente_retirada.observacao = "#{conta_corrente_retirada.lancamento.nome} DSTV"
    conta_corrente_retirada.save!

    return agent_submit_payment_hash
  end

  def self.alterar_pacote(customer_number, smartcard, produtos, ip, usuario_logado)
    raise PagasoError.new("Selecione pelo menos um produto") if produtos.blank?
    raise PagasoError.new("Customer number não pode ser vazio") if customer_number.blank?

    customer_number = customer_number.strip
    smartcard = smartcard.strip

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

    raise PagasoError.new("Valor da fatura é insuficiente para pagamento") if valor_total.to_f < 0.1
    raise PagasoError.new("Saldo insuficiente para realizar a operação, seu saldo atual é de KZ #{usuario_logado.saldo.round(2)}") if usuario_logado.saldo < valor_total.to_f

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros

    sequencial_numero = TIme.now.to_i
    
    paymentDescription = "Pagaso - #{usuario_logado.nome}".truncate(49)
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial_numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{valor_total}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>#{paymentDescription}</sel1:paymentDescription>
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

    raise PagasoError.new("Transação duplicada") if SequencialDstv.where(response_body: body).count > 0

    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial_numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    mensagem = xml_doc.child.child.child.children.select{|child| child.name == "faultstring"}.first.text rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise PagasoError.new("Pagamento não processado") if agent_submit_payment.blank?

    return agent_submit_payment_hash_parse(produtos_enviados.map{|produto| produto.description}.join(", "), produtos_enviados.map{|produto| produto.produto_id_parceiro}.join(", "), valor_total, agent_submit_payment, request, body, customer_number, usuario_logado, smartcard, "mensal", Lancamento::ALTERACAO_PACOTE)
  end

  def self.informacoes_device_number(smartcard, ip)
    raise PagasoError.new("Por favor digite o smartcard") if smartcard.blank?

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
    raise PagasoError.new("Por favor digite o customer number") if customer_number.blank?
    customer_number = customer_number.strip
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
    raise PagasoError.new("Por favor digite o smartcard") if smartcard.blank?
    raise PagasoError.new("Por favor digite o customer_number") if customer_number.blank?

    customer_number = customer_number.strip
    smartcard = smartcard.strip

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
    if get_due_amountand_date.blank? || request.body.scan(/<\/faultcode><faultstring/).length > 0
      mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
      raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?
      
      mensagem = xml_doc.child.child.child.children.select{|child| child.name == "faultstring"}.first.text rescue ""
      raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?
    end

    detail_hash = {}

    detail_hash["AuditReferenceNumber"] = get_due_amountand_date.children.select{|child| child.name == "AuditReferenceNumber"}.first.text rescue ""
    detail_hash["currency"] = get_due_amountand_date.children.select{|child| child.name == "currency"}.first.text rescue ""
    detail_hash["defaultCurrencyDueAmount"] = get_due_amountand_date.children.select{|child| child.name == "defaultCurrencyDueAmount"}.first.text rescue ""
    detail_hash["defaultCuurencyCode"] = get_due_amountand_date.children.select{|child| child.name == "defaultCuurencyCode"}.first.text rescue ""
    detail_hash["dueAmount"] = get_due_amountand_date.children.select{|child| child.name == "dueAmount"}.first.text rescue ""
    detail_hash["dueDate"] = get_due_amountand_date.children.select{|child| child.name == "dueDate"}.first.text rescue ""

    return detail_hash
  end

  def self.pagar_fatura(customer_number, valor, ip, usuario_logado, smartcard)
    raise PagasoError.new("Por favor digite o customer_number") if customer_number.blank?
    raise PagasoError.new("Smartcard é obrigatório") if smartcard.blank?
    raise PagasoError.new("Por favor digite o valor") if valor.blank?
    raise PagasoError.new("Valor da fatura é insuficiente para pagamento") if valor.to_f < 0.1
    raise PagasoError.new("Saldo insuficiente para realizar a operação, seu saldo atual é de KZ #{usuario_logado.saldo.round(2)}") if usuario_logado.saldo < valor.to_f
    
    customer_number = customer_number.strip
    smartcard = smartcard.strip

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language = parametros
    
    sequencial_numero = Time.now.to_i

    paymentDescription = "Pagaso - #{usuario_logado.nome}".truncate(49)
    body = "
    <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"  xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
      <soapenv:Header/>
      <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{sequencial_numero}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{valor}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>#{currency}</sel1:currency>
            <sel1:paymentDescription>#{paymentDescription}</sel1:paymentDescription>
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

    raise PagasoError.new("Transação duplicada") if SequencialDstv.where(response_body: body).count > 0

    request = fazer_request(url_service, body, "AgentSubmitPayment")
    SequencialDstv.create!(numero: sequencial_numero, request_body: request.body, response_body: body)
    
    xml_doc = Nokogiri::XML(request.body)

    mensagem = request.body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    mensagem = xml_doc.child.child.child.children.select{|child| child.name == "faultstring"}.first.text rescue ""
    raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?

    agent_submit_payment = xml_doc.child.child.child.children rescue nil
    raise PagasoError.new("Pagamento não processado") if agent_submit_payment.blank?

    agent_submit_payment_hash = {}

    agent_submit_payment_hash["receiptNumber"] = agent_submit_payment.children.select{|child| child.name == "receiptNumber"}.first.text rescue ""
    agent_submit_payment_hash["transactionNumber"] = agent_submit_payment.children.select{|child| child.name == "transactionNumber"}.first.text rescue ""
    agent_submit_payment_hash["status"] = agent_submit_payment.children.select{|child| child.name == "status"}.first.text rescue ""
    agent_submit_payment_hash["transactionDateTime"] = agent_submit_payment.children.select{|child| child.name == "transactionDateTime"}.first.text rescue ""
    agent_submit_payment_hash["errorMessage"] = agent_submit_payment.children.select{|child| child.name == "errorMessage"}.first.text rescue ""
    agent_submit_payment_hash["AuditReferenceNumber"] = agent_submit_payment.children.select{|child| child.name == "AuditReferenceNumber"}.first.text rescue ""

    pagamentos_faturas_dstv = Venda.new
    pagamentos_faturas_dstv.request_send = request.body
    pagamentos_faturas_dstv.response_get = body
    pagamentos_faturas_dstv.customer_number = customer_number
    pagamentos_faturas_dstv.smartcard = smartcard
    pagamentos_faturas_dstv.partner_id = Partner.dstv.id

    desconto_aplicado, valor_original, valor = Venda.desconto_venda(usuario_logado, Partner.dstv, valor)
    pagamentos_faturas_dstv.desconto_aplicado = desconto_aplicado
    pagamentos_faturas_dstv.valor_original = valor_original
    pagamentos_faturas_dstv.value = valor

    pagamentos_faturas_dstv.usuario_id = usuario_logado.id
    pagamentos_faturas_dstv.responsavel = usuario_logado
    pagamentos_faturas_dstv.receipt_number = agent_submit_payment_hash["receiptNumber"]
    pagamentos_faturas_dstv.transaction_number = agent_submit_payment_hash["transactionNumber"]
    pagamentos_faturas_dstv.status = agent_submit_payment_hash["status"]
    pagamentos_faturas_dstv.transaction_date_time = agent_submit_payment_hash["transactionDateTime"]
    pagamentos_faturas_dstv.audit_reference_number = agent_submit_payment_hash["AuditReferenceNumber"]
    pagamentos_faturas_dstv.lancamento_id = Lancamento.where(nome: Lancamento::PAGAMENTO_DE_FATURA).first.id rescue nil
    pagamentos_faturas_dstv.save!

    raise PagasoError.new(ErroAmigavel.traducao(agent_submit_payment_hash["errorMessage"])) if agent_submit_payment_hash["errorMessage"].present?

    conta_corrente_retirada = ContaCorrente.new
    conta_corrente_retirada.valor = "-#{valor.to_f.abs}"
    conta_corrente_retirada.usuario = usuario_logado
    conta_corrente_retirada.responsavel = usuario_logado
    conta_corrente_retirada.lancamento = Lancamento.where(nome: Lancamento::PAGAMENTO_DE_FATURA).first || Lancamento.first
    conta_corrente_retirada.responsavel_aprovacao_id = usuario_logado.id
    conta_corrente_retirada.observacao = "Pagamento de fatura DSTV"
    conta_corrente_retirada.save!

    return agent_submit_payment_hash
  end

  def self.parametros
    parceiro = Partner.dstv
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
      data_source = parametro.get.data_source_dstv_desenvolvimento
      payment_vendor_code = parametro.get.payment_vendor_code_dstv_desenvolvimento
      vendor_code = parametro.get.vendor_code_dstv_desenvolvimento
      agent_account = parametro.get.agent_account_dstv_desenvolvimento
      currency = parametro.get.currency_dstv_desenvolvimento
      product_user_key = parametro.get.product_user_key_dstv_desenvolvimento
      mop = parametro.get.mop_dstv_desenvolvimento # mop = "CASH, MOBILE or ATM " # WEB “Mobile, Web ou USSD”
      agent_number = parametro.get.agent_number_dstv_desenvolvimento #122434345
      business_unit = parametro.get.business_unit_desenvolvimento
      language = parametro.get.language_desenvolvimento
      customer_number_default = parametro.get.customer_number_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
      data_source = parametro.get.data_source_dstv_producao
      payment_vendor_code = parametro.get.payment_vendor_code_dstv_producao
      vendor_code = parametro.get.vendor_code_dstv_producao
      agent_account = parametro.get.agent_account_dstv_producao
      currency = parametro.get.currency_dstv_producao
      product_user_key = parametro.get.product_user_key_dstv_producao
      mop = parametro.get.mop_dstv_producao # mop = "CASH, MOBILE or ATM " # “Mobile, Web ou USSD”
      agent_number = parametro.get.agent_number_dstv_producao #122434345
      business_unit = parametro.get.business_unit_producao
      language = parametro.get.language_producao
      customer_number_default = parametro.get.customer_number_producao
    end

    [parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number,business_unit,language,customer_number_default]
  end

  def self.fazer_request(url_service, body, resource)
    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/#{resource}",
      },
      :body => body,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    Rails.logger.info "=========================================="
    Rails.logger.info body
    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="

    return request
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def self.informacoes_parse(body)
    xml_doc = Nokogiri::XML(body)

    customer_detail_hash = {}
    customer_details = xml_doc.child.child.child.child.children.select{|child| child.name == "customerDetails"}.first rescue nil
    accounts_xml = xml_doc.child.child.child.child.children.select{|child| child.name == "accounts"}.first rescue nil

    if customer_details.blank? || accounts_xml.blank?
      mensagem = body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
      raise PagasoError.new(ErroAmigavel.traducao(mensagem)) if mensagem.present?
    end

    if customer_details
      customer_details.children.each do |detail|
        customer_detail_hash["#{detail.name}"] = detail.text rescue ""
      end
    end

    accounts = []
    if accounts_xml
      accounts_xml.children.each do |account_xml|
        account = {}

        account_xml.children.each do |account_field_xml|
          account["#{account_field_xml.name}"] = account_field_xml.text rescue ""
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