class Dstv
  require 'openssl'

  def self.produtos
    partner = Partner.where(slug: "DSTv").first
    Produto.where(partner_id: partner.id)
  end

  def self.importa_produtos
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number = parametros
    
    # TODO - POC talvez se transformar em algo válido
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
         <soapenv:Header/>
         <soapenv:Body>
            <sel:GetAvailableProducts>
               <sel:dataSource>Angola</sel:dataSource>
               <sel:customerNumber>122364781</sel:customerNumber>
               <sel:BusinessUnit>DStv</sel:BusinessUnit>
               <sel:VendorCode>PagasoDStv</sel:VendorCode>
               <sel:language>?</sel:language>
               <sel:ipAddress>?</sel:ipAddress>
               <sel:interfaceType>?</sel:interfaceType>
            </sel:GetAvailableProducts>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, "GetAvailableProducts")

    if (200...300).include?(request.code.to_i)
      if request.body.present?
        puts "=========================================="
        puts request.body
        puts "=========================================="

        partner = Partner.where(slug: "DSTv").first
        
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

          produtos = Produto.where(produto_id_parceiro: produto_id_parceiro, partner_id: partner.id)
          if produtos.count == 0
            produto = Produto.new
            produto.produto_id_parceiro = produto_id_parceiro
            produto.partner_id = partner.id
          else
            produto = produtos.first
          end

          produto.responsavel = Usuario.adm
          produto.description = descricao

          produto.valor_compra_telemovel = price
          produto.valor_compra_site = price
          produto.valor_compra_pos = price
          produto.valor_compra_tef = price
          produto.valor_minimo_venda_telemovel = price
          produto.valor_minimo_venda_site = price
          produto.valor_minimo_venda_pos = price
          produto.valor_minimo_venda_tef = price


          produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{currency}')").first.id
          produto.status_produto = StatusProduto.where(nome: "Ativo").first

          produto.save!
        end

        puts "=========================================="
      end
    end
  end

  def self.informacoes_device_number(smartcard, ip)
    raise "Por favor digite o smartcard" if smartcard.blank?

    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByDeviceNumber>
              <sel:dataSource>#{data_source}</sel:dataSource>
              <sel:deviceNumber>#{smartcard}</sel:deviceNumber>
              <sel:currencyCode>AOA</sel:currencyCode>
              <sel:BusinessUnit>DStv</sel:BusinessUnit>
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <sel:language>PT</sel:language>
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
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByCustomerNumber>
              <sel:dataSource>#{data_source}</sel:dataSource>
              <sel:customerNumber>#{customer_number}</sel:customerNumber>
              <sel:currencyCode>AOA</sel:currencyCode>
              <sel:BusinessUnit>DStv</sel:BusinessUnit>
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <sel:language>PT</sel:language>
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
    parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number = parametros

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
          <sel:GetDueAmountandDate>
            <sel:dataSource>#{data_source}</sel:dataSource>
            <sel:customerNumber>#{customer_number}</sel:customerNumber>
            <sel:SCNumber>#{smartcard}</sel:SCNumber>
            <sel:BusinessUnit>DStv</sel:BusinessUnit>
            <sel:VendorCode>#{vendor_code}</sel:VendorCode>
            <sel:language>Portuguese</sel:language>
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
      mensagem = body.scan(/Message.*?\<\/Message/).first.gsub(/Message\>/, "").gsub(/\<\/Message/, "") rescue ""
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

    [parceiro,parametro,url_service,data_source,payment_vendor_code,vendor_code,agent_account,currency,product_user_key,mop,agent_number]
  end

  def self.fazer_request(url_service, body, resource)
    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    return HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/#{resource}",
      },
      :body => body
    )
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