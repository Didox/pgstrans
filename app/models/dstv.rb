class Dstv
  require 'openssl'

  def self.informacoes(smartcard)
    parceiro = Partner.where("lower(slug) = 'dstv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise "Parâmetros não localizados" if parametro.blank?
    raise "Parceiro não localizado" if parceiro.blank?
    raise "Por favor digite o smartcard" if smartcard.blank?

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
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByDeviceNumber>
              <!--Optional:-->
              <sel1:dataSource>#{data_source}</sel1:dataSource>
              <!--Optional:-->
              <sel:deviceNumber>#{smartcard}</sel:deviceNumber>
              <!--Optional:-->
              <sel:currencyCode>?</sel:currencyCode>
              <!--Optional:-->
              <sel:BusinessUnit>?</sel:BusinessUnit>
              <!--Optional:-->
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <!--Optional:-->
              <sel:language>PT</sel:language>
              <!--Optional:-->
              <sel:ipAddress>?</sel:ipAddress>
              <!--Optional:-->
              <sel:interfaceType>?</sel:interfaceType>
            </sel:GetCustomerDetailsByDeviceNumber>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    debugger

    request_send += "=========[GetCustomerDetailsByDeviceNumber]========"
    request_send += body
    request_send += "=========[GetCustomerDetailsByDeviceNumber]========"

    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/GetCustomerDetailsByDeviceNumber",
      },
      :body => body
    )

    debugger
    
    response_get += "=========[GetCustomerDetailsByDeviceNumber]========"
    response_get += request.body
    response_get += "=========[GetCustomerDetailsByDeviceNumber]========"

    last_request = request.body

    return []
  end
end