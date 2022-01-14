class Ende
  require 'openssl'

  TRADUCAO_DADOS = {
    "VAT" => "IVA"
  }

  def self.traducao(sigla)
    tra = TRADUCAO_DADOS[sigla]
    return tra || sigla
  end

  def self.validate_meter_number(meter_number)
    return false if meter_number.nil? || meter_number.empty?
    meter_number = meter_number.to_i.to_s
    return false if meter_number.length < 2

    is_odd = false;
    sum = 0;
  
    meter_number.reverse.scan(/\d/).each do |charactere|
      current_digit = charactere.to_i
      if is_odd
        doubled = current_digit * 2
        doubled_digits = doubled.to_s.scan(/\d/)
        doubled_digits.each do |c|
          sum += c.to_i
        end
      else
        sum += current_digit;
      end
      is_odd = !is_odd;
    end
    
    return (sum % 10 == 0);
  end

  def self.akz_parse(symbol)
    return symbol.to_s.upcase.strip == "AOA" ? "AKz" : symbol
  end

  def self.informacoes_meter_number(meter_number, uniq_number = nil)
    raise PagasoError.new("Por favor digite o Número do Medidor") if meter_number.blank?
    raise PagasoError.new("Número do Medidor inválido") if !Ende.validate_meter_number(meter_number)
    
    meter_number = meter_number.strip
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now) if uniq_number.blank?

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
            <clientID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\" />
            <terminalID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\" />
            <msgID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\" />
            <authCred
              xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
              <opName>#{parametro.operator_id}</opName>
              <password>#{parametro.password}</password>
            </authCred>
            <idMethod
              xmlns:q1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"
              xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xsi:type=\"q1:VendIDMethod\">
              <q1:meterIdentifier xsi:type=\"q1:MeterNumber\" msno=\"#{meter_number}\" />
            </idMethod>
          </sch:confirmCustomerReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return [informacoes_parse(request.body, uniq_number), body, request.body]
  end

  def self.venda_teste(usuario, ende_produto_id, meter_number, valor)
    valor = valor.to_f
    
    raise PagasoError.new("Por favor digite o Produto Recarga") if ende_produto_id.blank?
    raise PagasoError.new("Por favor digite o Número do Medidor") if meter_number.blank?
    raise PagasoError.new("Valor é obrigatório") if valor < 0.1
    raise PagasoError.new("Número do Medidor inválido") if !Ende.validate_meter_number(meter_number)

    meter_number = meter_number.strip
    parceiro,parametro,url_service = parametros

    desconto_aplicado, valor_original, valor = Venda.desconto_venda(usuario, parceiro, valor)

    raise PagasoError.new("Saldo insuficiente para recarga") if usuario.saldo < valor

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    body = 
    "
      <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
        <soap:Body>
        <trialCreditVendReq xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\">
          <clientID xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
          <terminalID xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
          <msgID dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
          <authCred xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
          <opName>#{parametro.operator_id}</opName>
          <password>#{parametro.password}</password>
          </authCred>
          <idMethod xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
          <meterIdentifier xsi:type=\"MeterNumber\" msno=\"#{meter_number}\"/>
          </idMethod>
          <purchaseValue xsi:type=\"PurchaseValueCurrency\">
          <amt value=\"#{valor}\" symbol=\"AOA\"/>
          </purchaseValue>
        </trialCreditVendReq>
        </soap:Body>
      </soap:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return [informacoes_parse(request.body, uniq_number), body, request.body]
  end

  def self.reprint(meter_number)
    raise PagasoError.new("Por favor digite o Número do Medidor") if meter_number.blank?
    raise PagasoError.new("Número do Medidor inválido") if !Ende.validate_meter_number(meter_number)
    
    meter_number = meter_number.strip
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
        <q1:meterIdentifier xsi:type=\"q1:MeterNumber\" msno=\"#{meter_number}\"/>
        </idMethod>
      </reprintReq>
      </soap:Body>
    </soap:Envelope>
    "

    request = fazer_request(url_service, body, uniq_number)
    return [informacoes_parse(request.body, uniq_number), body, request.body]
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
    return [informacoes_parse(request.body, uniq_number), body, request.body]
  end

  def self.pagamento_de_conta(numero_conta, valor_pagamento)
    parceiro,parametro,url_service = parametros

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)

    body = "
    <soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
    <soap:Body>
     <payAccReq xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\">
      <clientID xsi:type=\"EANDeviceID\" ean=\"#{parametro.client_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
      <terminalID xsi:type=\"EANDeviceID\" ean=\"#{parametro.terminal_id}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
      <msgID dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\" xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\"/>
      <authCred xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
      <opName>#{parametro.operator_id}</opName>
      <password>#{parametro.password}</password>
      </authCred>
      <reqAmt value=\"#{valor_pagamento}\" symbol=\"AOA\"/>
      <payType xmlns:q1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"q1:Cash\">
       <q1:tenderAmt value=\"100\" symbol=\"AOA\"/>
      </payType>
      <payAccount xsi:type=\"DebtRecovery\">
       <idMethod xmlns:q2=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"q2:CustIDMethod\">
        <q2:custIdentifier xsi:type=\"q2:CustAccountNo\" accNo=\"#{numero_conta}\"/>
       </idMethod>
      </payAccount>
      <vendingServerId>1</vendingServerId>
     </payAccReq>
    </soap:Body>
  </soap:Envelope>
  "
   
    request = fazer_request(url_service, body, uniq_number)
    return [informacoes_parse(request.body, uniq_number), body, request.body]
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

  def self.informacoes_xml(body, uniq_number)
    info = {}

    if body.scan(/<fault .*?<\/fault>/).length > 0
      info = {
        "erro" => ErroAmigavel.traducao(Nokogiri::XML(body.scan(/<fault .*?<\/fault>/).first).text),
        "respDateTime" => Nokogiri::XML(body.scan(/<respDateTime .*?<\/respDateTime>/).first).text.to_datetime
      }
    end

    xml_doc = Nokogiri::XML(body)

    xml_itens = xml_doc.children.children.children.children.children
    xml_itens.each do |info|
      info.each do |key, value|
        info[key] = value
      end
    end

    cliente_xml = Nokogiri::XML(body.scan(/<custVendDetail .*?\/>/).first).children.first
    info["name"] = cliente_xml["name"] rescue nil
    info["address"] = cliente_xml["address"] rescue nil
    info["contactNo"] = cliente_xml["contactNo"] rescue nil
    info["accNo"] = cliente_xml["accNo"] rescue nil
    info["daysLastPurchase"] = cliente_xml["daysLastPurchase"] rescue nil
    info["locRef"] = cliente_xml["locRef"] rescue nil
    info["utilityType"] = cliente_xml["utilityType"] rescue nil
    info["taxReferenceNo"] = cliente_xml["taxReferenceNo"] rescue nil
    info["minVendAmt"] = cliente_xml(/minVendAmt=\".*?\"/).first.remove(/minVendAmt=\"|\"/) rescue nil
    info["maxVendAmt"] = cliente_xml(/maxVendAmt=\".*?\"/).first.remove(/maxVendAmt=\"|\"/) rescue nil
    
    info["accountName"] = body.to_s.downcase.scan(/<accountname.*?<\/accountname>/).first.gsub(/<[^>]*>/, "") rescue ""
    info["stsCipher"] = body.to_s.downcase.scan(/<q\d:stscipher.*?<\/q\d:stscipher>/).first.gsub(/<[^>]*>/, "") rescue ""
    info["msno"] = body.scan(/msno=\".*?\"/).first.remove(/msno=\"|\"/) rescue nil
    info["canVend"] = xml_itens.to_xml.scan(/canVend.*?true<\/canVend/).length > 0 ? true : false
    info["minVendAmt"] = body.scan(/minVendAmt=\".*?\"/).first.remove(/minVendAmt=\"|\"/) rescue nil
    info["maxVendAmt"] = body.scan(/maxVendAmt=\".*?\"/).first.remove(/maxVendAmt=\"|\"/) rescue nil
    info["respDateTime"] = Nokogiri::XML(body.scan(/<respDateTime .*?<\/respDateTime>/).first).text.to_datetime rescue nil
    info["unique_number"] = uniq_number.unique_number
    info["receiptNo"] = body.scan(/receiptNo=\".*?\"/).first.remove(/receiptNo=\"|\"/) rescue nil
    info["amtvalue"] = body.scan(/amtvalue=\".*?\"/).first.remove(/amtvalue=\"|\"/) rescue nil
    info["symbol"] = body.scan(/symbol=\".*?\"/).first.remove(/symbol=\"|\"/) rescue nil
    info["krn"] = body.scan(/krn=\".*?\"/).first.remove(/krn=\"|\"/) rescue nil
    info["ti"] = body.scan(/ti=\".*?\"/).first.remove(/ti=\"|\"/) rescue nil
    info["sgc"] = body.scan(/sgc=\".*?\"/).first.remove(/sgc=\"|\"/) rescue nil
    info["unitOfMeasurement"] = body.scan(/unitOfMeasurement=\".*?\"/).first.remove(/unitOfMeasurement=\"|\"/) rescue nil
    info["tt"] = body.scan(/tt=\".*?\"/).first.remove(/tt=\"|\"/) rescue nil
    info["siUnit"] = body.scan(/siUnit=\".*?\"/).first.remove(/siUnit=\"|\"/) rescue nil
    info["rate_value"] = body.scan(/rate_value=\".*?\"/).first.remove(/rate_value=\"|\"/) rescue nil
    info["units_value"] = body.scan(/units_value=\".*?\"/).first.remove(/units_value=\"|\"/) rescue nil
    info["type"] = body.scan(/type=\".*?\"/).first.remove(/type=\"|\"/) rescue nil
    
    attributes_avail_credit = Nokogiri::XML(body.scan(/<availCredit.*?\/>/).first).children.first.attributes rescue nil
    if attributes_avail_credit.present?
      info["availCredit"] = {
        "value" => attributes_avail_credit["value"].value,
        "symbol" => attributes_avail_credit["symbol"].value,
      }
    end
   
    tariff = Nokogiri::XML(body.scan(/<tariff.*?<\/tariff>/).first).children.first.to_xml rescue nil
    if tariff.present?
      tariff = Nokogiri::XML(tariff.scan(/<name.*?<\/name>/).first).children.first.text rescue ""
      info["tariff"] = tariff
    end
   
    tariff_breakdown_xml = []
    steps = body.scan(/<tariffBreakdown .*?<\/tariffBreakdown>/).first.scan(/<q\d:Step.*?<\/q\d:Step>/) rescue []
    steps.each do |step|
      steps = Nokogiri::XML(step).children.first.children rescue []
      steps.each do |item|
        tariff_breakdown_xml << { 
          "name" => item.name.to_s.remove(/q\d\:/),
          "value" => item.to_h 
        }
      end
    end

    info["tariffBreakdown"] = tariff_breakdown_xml rescue []

    tx = Nokogiri::XML(body.scan(/<tx xsi:type=\"ServiceChrgTx\">.*?<\/tx>/).first) rescue nil
    if tx.present?
      symbol = tx.children.first.xpath("//amt").first.attributes["symbol"].value rescue ""
      value = tx.children.first.xpath("//amt").first.attributes["value"].value rescue ""
      accDesc = tx.children.first.xpath("//accDesc").first.text rescue ""
      info["ServiceChrgTx"] = {
        "symbol" => symbol,
        "value" => value,
        "accDesc" => accDesc
      }
    end

    creditVendTx = body.scan(/<tx xsi:type=\"CreditVendTx\".*?<\/tx>/)
    if creditVendTx.present?
      info["CreditVendTx"] = []
      creditVendTx.each do |xml|
        tx = Nokogiri::XML(xml) rescue nil

        symbol = tx.children.first.xpath("//amt").first.attributes["symbol"].value rescue ""
        value = tx.children.first.xpath("//amt").first.attributes["value"].value rescue ""
        stsCipher = xml.downcase.scan(/<q\d:stscipher.*?<\/q\d:stscipher>/).first.gsub(/<[^>]*>/, "") rescue ""
        desc = xml.scan(/<q\d\:desc.*?<\/q\d:desc>/).first.gsub(/<[^>]*>/, "") rescue ""
        meterDetail = Nokogiri::XML(xml.downcase.scan(/<q\d:meterdetail.*?<\/q\d:meterdetail>/).first).children.first.attributes rescue {}
        units = Nokogiri::XML(xml.downcase.scan(/<q\d:units.*?\/>/).first).children.first.attributes rescue {}
        
        info["CreditVendTx"] << {
          "symbol" => symbol,
          "value" => value,
          "stsCipher" => stsCipher,
          "desc" => desc,
          "meterDetail" => {
            "sgc" => (meterDetail["sgc"].value rescue ""),
            "msno" => (meterDetail["msno"].value rescue ""),
          },
          "units" => {
            "value" => (units["value"].value rescue ""),
            "siUnit" => (units["siunit"].value rescue ""),
          }
        }
      end
    end

    tx = Nokogiri::XML(body.scan(/<tx xsi:type=\"DebtRecoveryTx\".*?<\/tx>/).first) rescue nil
    if tx.present?
      amt_symbol = tx.children.first.xpath("//amt").first.attributes["symbol"].value rescue ""
      amt_value = tx.children.first.xpath("//amt").first.attributes["value"].value rescue ""
      balance_symbol = tx.children.first.xpath("//balance").first.attributes["symbol"].value rescue ""
      balance_value = tx.children.first.xpath("//balance").first.attributes["value"].value rescue ""
      accDesc = tx.children.first.xpath("//accDesc").first.text rescue ""
      accNo = tx.children.first.xpath("//accNo").first.text rescue ""

      info["DebtRecoveryTx"] = {
        "amt" => {
          "symbol" => amt_symbol,
          "value" => amt_value,
        },
        "balance" => {
          "symbol" => balance_symbol,
          "value" => balance_value,
        },
        "accDesc" => accDesc,
        "accNo" => accNo
      }
    end

    info["ServiceChrgTx"] = []
    body.scan(/<tx xsi:type=\"ServiceChrgTx\".*?<\/tx>/).each do |xml|
      tx = Nokogiri::XML(xml) rescue nil
      if tx.present?
        amt_symbol = tx.children.first.xpath("//amt").first.attributes["symbol"].value rescue ""
        amt_value = tx.children.first.xpath("//amt").first.attributes["value"].value rescue ""
        balance_symbol = tx.children.first.xpath("//balance").first.attributes["symbol"].value rescue ""
        balance_value = tx.children.first.xpath("//balance").first.attributes["value"].value rescue ""
        accDesc = tx.children.first.xpath("//accDesc").first.text rescue ""
        accNo = tx.children.first.xpath("//accNo").first.text rescue ""

        info["ServiceChrgTx"] << {
          "amt" => {
            "symbol" => amt_symbol,
            "value" => amt_value,
          },
          "balance" => {
            "symbol" => balance_symbol,
            "value" => balance_value,
          },
          "accDesc" => accDesc,
          "accNo" => accNo
        }
      end
    end

    creditTokenIssues = body.scan(/<creditTokenIssue.*?<\/creditTokenIssue>/)
    if creditTokenIssues.present?
      info["creditTokenIssue"] = []
      creditTokenIssues.each do |xml|
        tx = Nokogiri::XML(xml) rescue nil
        desc = xml.scan(/<q\d\:desc.*?<\/q\d:desc>/).first.gsub(/<[^>]*>/, "") rescue ""
        units = Nokogiri::XML(xml.scan(/<q\d:units.*?\/>/).first).children.first.attributes rescue {}
        
        info["creditTokenIssue"] << {
          "desc" => desc,
          "units" => {
            "siUnit" => units["siUnit"].value,
            "value" => units["value"].value,
          }
        }
      end
    end

    attributes = Nokogiri::XML(body.scan(/<tenderAmt .*?\/>/).first).children.first.attributes rescue nil
    if attributes.present?
      info["tenderAmt"] = {
        "symbol" => attributes["symbol"],
        "value" => attributes["value"]
      }
    end

    attributes = Nokogiri::XML(body.scan(/<change .*?\/>/).first).children.first.attributes rescue nil
    if attributes.present?
      info["change"] = {
        "symbol" => attributes["symbol"],
        "value" => attributes["value"]
      }
    end

    return info
  end

  def self.informacoes_parse(body, uniq_number)
    body.remove!(/=========.*?========/)

    reprints = body.scan(/<reprint .*?<\/reprint>/)
    if reprints.length > 1
      info = []
      reprints.each do |reprint|
        info << informacoes_xml(reprint, uniq_number)
      end
      return info
    end
    
    return [informacoes_xml(body, uniq_number)]
  end

  def self.fazer_request(url, body, uniq_number)
    uniq_number.xml_enviado = body
    uniq_number.save

    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => ""
      },
      :body => body,
      :timeout => 120.seconds
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