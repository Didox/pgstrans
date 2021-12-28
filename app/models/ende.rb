class Ende
  require 'openssl'

  def self.informacoes_customer_number(customer_number)
    raise PagasoError.new("Por favor digite o customer number") if customer_number.blank?
    customer_number = customer_number.strip
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    body = "
      <soapenv:Envelope
        xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\"
        xmlns:sch=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\"
        xmlns:sch1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"
        xmlns:sch2=\"http://www.nrs.eskom.co.za/xmlvend/meter/2.1/schema\">
        <soapenv:Header/>
        <soapenv:Body>
          <sch:confirmCustomerReq
            xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
            xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
            <vendingServerID
              xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">1
            </vendingServerID>
            <clientID
              xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\" />
              <terminalID
                xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\" />
                <msgID
                  xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\" />
                  <authCred
                    xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
                    <opName>#{parametro.operator_id}</opName>
                    <password>#{parametro.password}</password>
                  </authCred>
                  <idMethod
                    xmlns:q1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"
                    xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xsi:type=\"q1:VendIDMethod\">
                    <q1:meterIdentifier xsi:type=\"q1:MeterNumber\" msno=\"#{customer_number}\" />
                  </idMethod>
          </sch:confirmCustomerReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return informacoes_parse(request.body, uniq_number)
  end

  def self.venda_teste(ende_produto_id, ende_medidor)
    raise PagasoError.new("Por favor digite o Produto Recarga") if ende_produto_id.blank?
    raise PagasoError.new("Por favor digite o Número do Contador ou Medidor") if ende_medidor.blank?
    
    ende_medidor = ende_medidor.strip
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    valor = Produto.find(ende_produto_id).valor_compra_telemovel

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xmlns:sch1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xmlns:sch2=\"http://www.nrs.eskom.co.za/xmlvend/meter/2.1/schema\">
      <soapenv:Header/>
      <soapenv:Body>
      <sch:creditVendReq xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
        <clientID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\"/>
        <terminalID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\"/>
        <msgID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\"/>
        <authCred xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <opName>#{parametro.operator_id}</opName>
        <password>#{parametro.password}</password>
        </authCred>
                            
        <idMethod xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <meterIdentifier xsi:type=\"MeterNumber\" msno=\"#{ende_medidor}\"/>
        </idMethod>
        <purchaseValue xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xsi:type=\"PurchaseValueCurrency\">
        <amt value=\"#{valor}\" symbol=\"AOA\"/>
        </purchaseValue>
      </sch:creditVendReq>
      </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return request.body
  end

  def self.reprint(ende_medidor)
    raise PagasoError.new("Por favor digite o Número do Contador ou Medidor") if ende_medidor.blank?
    
    ende_medidor = ende_medidor.strip
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    body = "
      <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
      <soap:Body>
      <reprintReq xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\">
        <clientID xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
        <terminalID xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
        <msgID dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
        <authCred xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <opName>#{parametro.operator_id}</opName>
        <password>#{parametro.password}</password>
        </authCred>
        <idMethod xmlns:q1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"q1:VendIDMethod\">
        <q1:meterIdentifier xsi:type=\"q1:MeterNumber\" msno=\"#{ende_medidor}\"/>
        </idMethod>
      </reprintReq>
      </soap:Body>
    </soap:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return request.body
  end

  def self.last_advice(date_time, unique_number_enviado)
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    body = "
      <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
      <soap:Body>
        <adviceReq xsi:type=\"LastRespAdviceReq\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <clientID xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\"/>
        <terminalID xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\"/>
        <msgID dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\"/>
        <authCred>
          <opName>#{parametro.operator_id}</opName>
          <password>#{parametro.password}</password>
        </authCred>
        <adviceReqMsgID dateTime=\"#{date_time.to_datetime.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{unique_number_enviado}\"/>
        </adviceReq>
      </soap:Body>
      </soap:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return request.body
  end

  def self.parametros
    parceiro = Partner.ende
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?

    url_service = Rails.env == "development" ? "#{parametro.url_integracao_desenvolvimento}" : "#{parametro.url_integracao_producao}"
    [parceiro,parametro,url_service]
  end

  def self.children_text(children)
    return "" if children.blank?

    @index ||= 0
    @index += 1

    # return children.to_xml

    html = ""

    name = children.name rescue nil
    html += "<b>name:</b> #{name}<br>" if name.present?

    qtd = children.size rescue 0
    if qtd > 0
      children.each do |child|
        name = child.name rescue nil
        html += "<b>name:</b> #{name}<br>" if name.present?

        value = child.value rescue nil
        html += "<b>value:</b> #{value}<br>" if value.present?

        values = child.values rescue nil
        html += "<b>values:</b> #{values.join(" ")}<br>" if values.present?

        html += attributes_xml(children)

        childs = children.children rescue nil
        html += children_text(childs) if childs.present? && @index < 38
      end
    else
      html += "<b>text:</b> #{children.text}<br>" if children.text.present?
      html += attributes_xml(children)
      
      childs = children.children rescue nil
      html += children_text(childs) if childs.present? && @index < 38
    end

    return html
  end

  def self.attributes_xml(children)
    attributes = children.attributes rescue nil
    html = ""
    if attributes.present?
      if attributes["name"].present?
        html += "<b>name: </b> #{attributes["name"].value}<br>"
      end
      if attributes["address"].present?
        html += "<b>address: </b> #{attributes["address"].value}<br>"
      end
      if attributes["taxRef"].present?
        html += "<b>taxRef: </b> #{attributes["taxRef"].value}<br>"
      end
      if attributes["type"].present?
        html += "<b>Type: </b> #{attributes["type"].value}<br>"
      end
      if attributes["ean"].present?
        html += "<b>Ean: </b> #{attributes["ean"].value}<br>"
      end
      if attributes["dateTime"].present?
        html += "<b>DateTime: </b> #{attributes["dateTime"]}<br>"
      end
      if attributes["availCredit"].present?
        html += "<b>availCredit: </b> #{attributes["availCredit"]}<br>"
      end
      if attributes["contactNo"].present?
        html += "<b>contactNo: </b> #{attributes["contactNo"]}<br>"
      end
      if attributes["accNo"].present?
        html += "<b>accNo: </b> #{attributes["accNo"]}<br>"
      end
      if attributes["locRef"].present?
        html += "<b>locRef: </b> #{attributes["locRef"]}<br>"
      end
      if attributes["utilityType"].present?
        html += "<b>utilityType: </b> #{attributes["utilityType"]}<br>"
      end
      if attributes["daysLastPurchase"].present?
        html += "<b>daysLastPurchase: </b> #{attributes["daysLastPurchase"]}<br>"
      end
      if attributes["receiptNo"].present?
        html += "<b>receiptNo: </b> #{attributes["receiptNo"]}<br>"
      end
      if attributes["uniqueNumber"].present?
        html += "<b>UniqueNumber: </b> #{attributes["uniqueNumber"]}<br>"
      end
      if attributes["krn"].present?
        html += "<b>krn: </b> #{attributes["krn"]}<br>"
      end
      if attributes["ti"].present?
        html += "<b>ti: </b> #{attributes["ti"]}<br>"
      end
      if attributes["sgc"].present?
        html += "<b>sgc: </b> #{attributes["sgc"]}<br>"
      end
      if attributes["unitOfMeasurement"].present?
        html += "<b>unitOfMeasurement: </b> #{attributes["unitOfMeasurement"]}<br>"
      end
      if attributes["msno"].present?
        html += "<b>msno: </b> #{attributes["msno"]}<br>"
      end
      if attributes["tt"].present?
        html += "<b>tt: </b> #{attributes["tt"]}<br>"
      end
      if attributes["siUnit"].present?
        html += "<b>siUnit: </b> #{attributes["siUnit"]}<br>"
      end
      if attributes["value"].present?
        html += "<b>value:</b> #{children2.attributes["value"].value}<br>"
      end
      if attributes["symbol"].present?
        html += "<b>symbol:</b> #{attributes["symbol"].value}<br>"
      end
    end

    return html
  end

  def self.informacoes_parse(body, uniq_number)
    if body.scan(/<fault .*?<\/fault>/).length > 0
      return {
        "erro" => Nokogiri::XML(body.scan(/<fault .*?<\/fault>/).first).text,
        "respDateTime" => Nokogiri::XML(body.scan(/<respDateTime .*?<\/respDateTime>/).first).text.to_datetime
      }
    end

    xml_doc = Nokogiri::XML(body)

    @info = {}
    xml_itens = xml_doc.children.children.children.children.children
    xml_itens.each do |info|
      info.each do |key, value|
        @info[key] = value
      end
    end

    @info["canVend"] = xml_itens.to_xml.scan(/canVend.*?true<\/canVend/).length > 0 ? true : false
    @info["minVendAmt"] = Nokogiri::XML(xml_itens.to_xml.scan(/<minVendAmt.*?>/).first).children.first.to_h rescue {}
    @info["maxVendAmt"] = Nokogiri::XML(xml_itens.to_xml.scan(/<maxVendAmt.*?>/).first).children.first.to_h rescue {}
    @info["respDateTime"] = Nokogiri::XML(body.scan(/<respDateTime .*?<\/respDateTime>/).first).text.to_datetime rescue nil
    @info["unique_number"] = uniq_number.unique_number

    @info
  end

  def self.fazer_request(url, body, uniq_number)
    uniq_number.xml_enviado = body
    uniq_number.save

    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "",
      },
      :body => body
    )

    uniq_number.xml_recebido = request.body
    uniq_number.save

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
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.backtrace}"
  end
end