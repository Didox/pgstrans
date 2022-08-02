class Africell
  require 'openssl'

  def self.produtos
    partner = Partner.africell
    Produto.produtos.where(partner_id: partner.id)
  end

  def self.produtos_ativos
    produtos = Africell.produtos
    produtos = produtos.where("valor_compra_telemovel > 0 and produto_id_parceiro is not null and produto_id_parceiro <> ''").reorder("valor_compra_telemovel asc")
    produtos
  end

  def self.consulta_saldo
  end

  def self.parametros
    parceiro = Partner.africell
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?

    if Rails.env == "development"
      url_service = parametro.url_integracao_desenvolvimento
      data_source = parametro.data_source_africell_desenvolvimento
      payment_vendor_code = parametro.payment_vendor_code_africell_desenvolvimento
      vendor_code = parametro.vendor_code_africell_desenvolvimento
      agent_account = parametro.agent_account_africell_desenvolvimento
      currency = parametro.currency_africell_desenvolvimento
      product_user_key = parametro.product_user_key_africell_desenvolvimento
      mop = parametro.mop_africell_desenvolvimento # mop = "CASH, MOBILE or ATM "
      agent_number = parametro.agent_number_africell_desenvolvimento #122434345
      business_unit = parametro.business_unit_desenvolvimento
      language = parametro.language_desenvolvimento
      customer_number_default = parametro.customer_number_desenvolvimento
    else
      url_service = parametro.url_integracao_producao
      data_source = parametro.data_source_africell_producao
      payment_vendor_code = parametro.payment_vendor_code_africell_producao
      vendor_code = parametro.vendor_code_africell_producao
      agent_account = parametro.agent_account_africell_producao
      currency = parametro.currency_africell_producao
      product_user_key = parametro.product_user_key_africell_producao
      mop = parametro.mop_africell_producao # mop = "CASH, MOBILE or ATM "
      agent_number = parametro.agent_number_africell_producao #122434345
      business_unit = parametro.business_unit_producao
      language = parametro.language_producao
      customer_number_default = parametro.customer_number_producao
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