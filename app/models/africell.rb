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
  
  def self.login
    parceiro, parametro, url_service = self.parametros
    url = "#{url_service}/#{parametro.get.endpoint_HTTP_Login}"
    uri = URI.parse(URI::Parser.new.escape(url))

    basic_base64_authentication = "#{parametro.get.basic_base64_authentication}"

    request = HTTParty.get(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{basic_base64_authentication}",
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "===================[login]======================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="
    AfricellLogin.create(body_request:request.body.to_json)
  end

  
  def self.validate_otp(parceiro, parametro, url_service)
    url = "#{url_service}#{parametro.get.endpoint_HTTP_ValidateOTP}"
    uri = URI.parse(URI::Parser.new.escape(url))

    basic_base64_authentication = "#{parametro.get.basic_base64_authentication}"

    otp = parametro.get.otp_key
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Basic #{basic_base64_authentication}",
      'otp' => "#{otp}",
    }

    puts "======[OTP body]========="
    puts headers.inspect
    puts "======[OTP]========="

    request = HTTParty.get(uri, 
    :headers => headers,
    timeout: DEFAULT_TIMEOUT.to_i.seconds)


    
    puts "======[OTP request]========="
    puts request.inspect
    puts "======[OTP]========="

    request.headers["authorization"]
  end

  def self.refresh_token(get_token_force = false)
    parceiro, parametro, url_service = Africell.parametros
    if get_token_force
      token = Africell.validate_otp(parceiro, parametro, url_service)
      dados = parametro.get["table"]
      dados["africell_token"] = token
      Parametro.where(id: parametro.id).update_all(dados: dados.to_json)
    else
      token = parametro.get["table"]["africell_token"]
    end

    url = "#{url_service}#{parametro.get.endpoint_HTTP_RefreshToken}"
    uri = URI.parse(URI::Parser.new.escape(url))

    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => token
    }

    puts("=======[refresh headers]=======")
    puts(headers.inspect)
    puts("==============")

    request = HTTParty.get(uri, 
    :headers => headers,
    timeout: DEFAULT_TIMEOUT.to_i.seconds)

    puts("=======[refresh request]=======")
    puts(request.inspect)
    puts("==============")

    [request.headers["authorization"],parceiro, parametro, url_service]
  end

  def self.consulta_saldo
    jwt_token, parceiro, parametro, url_service = Africell.refresh_token
    url = "#{url_service}/#{parametro.get.endpoint_HTTPC_CheckDealerBalance}"
    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.get(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => jwt_token,
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="

    dados = JSON.parse(request.body)
    SaldoParceiro.create(partner_id: parceiro.id, saldo: dados["DealerBalance"], log: request.body)
  end

  def self.vender
    jwt_token, parceiro, parametro, url_service = Africell.refresh_token
    url = "#{url_service}#{parametro.get.endpoint_HTTP_Recharge}"
    uri = URI.parse(URI::Parser.new.escape(url))
    
    body = {
      'ProductCode': '01',
      'ParameterCode': '01',
      'Amount': '',
      'TargetMSISDN': '244959560801',
      'TransactionReference': '1'
    }.to_json

    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => jwt_token,
      },
      body: body
    )

    request

=begin
    puts("========[token]===========")
    puts(jwt_token)
    puts("===================")
    

    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="



    puts "=========URL================"
    puts url
    puts "=========URL================"
    puts "http://10.250.80.74:9214/HTTP_Recharge/"
    puts "=========URL================"


    result = "curl -X POST http://10.250.80.74:9214/HTTP_Recharge/ -H \"Content-Type: application/json\" -H \"Authorization: #{jwt_token}\" -d '{\"ProductCode\":\"01\", \"ParameterCode\":\"01\", \"Amount\":\"\", \"TargetMSISDN\":\"244959560801\", \"TransactionReference\":\"1\"}'"
   
    result = `#{result}`
    Rails.logger.info "==============[Result]============================"
    puts result
    Rails.logger.info "=========================================="
=end
  end

  def self.check_transaction_log(params)
    jwt_token, parceiro, parametro, url_service = Africell.refresh_token
    url = "#{url_service}#{parametro.get.endpoint_HTTP_CheckTransactionLog}"
    uri = URI.parse(URI::Parser.new.escape(url))

    body = {
      'TargetMSISDN': params[:target_msisdn],
      'TransactionReference': params[:request_id],
      'TransactionId': '5',
      #numero da transacao Africell - identificar
      'Status': '',
      #status branco
      'Limit': 20,
      #limite 20
    }.to_json

    request = HTTParty.get(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => jwt_token,
      },
      body: body
    )

    JSON.parse(request.body)
  end

  def self.parametros
    parceiro = Partner.africell
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
    end

    [parceiro,parametro,url_service]
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