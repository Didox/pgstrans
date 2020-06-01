class Dstv
  require 'openssl'

  def self.importa_produtos
    # TODO - POC talvez se transformar em algo válido
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
         <soapenv:Header/>
         <soapenv:Body>
            <sel:GetAvailableProducts>
               <!--Optional:-->
               <sel:dataSource>Angola</sel:dataSource>
               <!--Optional:-->
               <sel:customerNumber>122364781</sel:customerNumber>
               <!--Optional:-->
               <sel:BusinessUnit>DStv</sel:BusinessUnit>
               <!--Optional:-->
               <sel:VendorCode>PagasoDStv</sel:VendorCode>
               <!--Optional:-->
               <sel:language>?</sel:language>
               <!--Optional:-->
               <sel:ipAddress>?</sel:ipAddress>
               <!--Optional:-->
               <sel:interfaceType>?</sel:interfaceType>
            </sel:GetAvailableProducts>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    url = "http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://services.multichoice.co.za/SelfCare/ISelfCareService/GetAvailableProducts',
      },
      :body => body)
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

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
            <sel:GetCustomerDetailsByDeviceNumber>
              <!--Optional:-->
              <sel:dataSource>#{data_source}</sel:dataSource>
              <!--Optional:-->
              <sel:deviceNumber>#{smartcard}</sel:deviceNumber>
              <!--Optional:-->
              <sel:currencyCode>AOA</sel:currencyCode>
              <!--Optional:-->
              <sel:BusinessUnit>DStv</sel:BusinessUnit>
              <!--Optional:-->
              <sel:VendorCode>#{vendor_code}</sel:VendorCode>
              <!--Optional:-->
              <sel:language>PT</sel:language>
              <!--Optional:-->
              <sel:ipAddress>IP 1</sel:ipAddress>
              <!--Optional:-->
              <sel:interfaceType>?</sel:interfaceType>
            </sel:GetCustomerDetailsByDeviceNumber>
        </soapenv:Body>
      </soapenv:Envelope>
    "

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

    xml_doc = Nokogiri::XML(request.body)

    customerDetailsHash = {}
    customerDetails = xml_doc.child.child.child.child.children.select{|child| child.name == "customerDetails"}.first rescue nil
    if customerDetails
      customerDetails.children.each do |detail|
        customerDetailsHash["#{detail.name}"] = detail.text
      end
    end

    accounts = []
    accounts_xml = xml_doc.child.child.child.child.children.select{|child| child.name == "accounts"}.first rescue nil
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
      customerDetail: customerDetailsHash,
      accounts: accounts
    }
  end
end