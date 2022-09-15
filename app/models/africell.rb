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

    Rails.logger.info "======[OTP body]========="
    Rails.logger.info headers.inspect
    Rails.logger.info "======[OTP]========="

    request = HTTParty.get(uri, 
    :headers => headers,
    timeout: DEFAULT_TIMEOUT.to_i.seconds)
  
    Rails.logger.info "======[OTP request]========="
    Rails.logger.info request.inspect
    Rails.logger.info "======[OTP]========="

    request.headers["authorization"]
  rescue Exception => e
    Rails.logger.info "=========================="
    Rails.logger.info e.message
    Rails.logger.info "=========================="
    Rails.logger.info e.backtrace
    Rails.logger.info "=========================="
    raise "Validação OTP não realizada - #{e.message}"
  end

  def self.refresh_token(get_token_force = false)
    parceiro, parametro, url_service = Africell.parametros

    token_param = parametro.get["table"]["africell_token"] rescue ""
    if get_token_force || token_param.blank?
      token = Africell.validate_otp(parceiro, parametro, url_service)
      dados = JSON.parse(parametro.dados) rescue {}
      dados["africell_token"] = token
      Parametro.where(id: parametro.id).update_all(dados: dados.to_json)
    else
      token = token_param
    end

    url = "#{url_service}#{parametro.get.endpoint_HTTP_RefreshToken}"
    uri = URI.parse(URI::Parser.new.escape(url))

    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => token
    }

    Rails.logger.info("=======[refresh headers]=======")
    Rails.logger.info(headers.inspect)
    Rails.logger.info("==============")

    request = HTTParty.get(uri, 
    :headers => headers,
    timeout: DEFAULT_TIMEOUT.to_i.seconds)

    Rails.logger.info("=======[refresh request]=======")
    Rails.logger.info(request.inspect)
    Rails.logger.info("==============")

    [request.headers["authorization"],parceiro, parametro, url_service]
  rescue Exception => e
    Rails.logger.info "=========================="
    Rails.logger.info e.message
    Rails.logger.info "=========================="
    Rails.logger.info e.backtrace
    Rails.logger.info "=========================="
    raise "Refresh token não realizada - #{e.message}"
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

    raise "Retorno da API vazia, não foi possível recuperar o DealerBalance" if dados.blank?

    SaldoParceiro.create(partner_id: parceiro.id, saldo: dados["DealerBalance"], log: request.body)
    
  rescue Exception => e
    Rails.logger.info "=========================="
    Rails.logger.info e.message
    Rails.logger.info "=========================="
    Rails.logger.info e.backtrace
    Rails.logger.info "=========================="
    raise "Consulta de saldo não realizada - #{e.message}"
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
    Rails.logger.info("========[token]===========")
    Rails.logger.info(jwt_token)
    Rails.logger.info("===================")
    

    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "=========================================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="



    Rails.logger.info "=========URL================"
    Rails.logger.info url
    Rails.logger.info "=========URL================"
    Rails.logger.info "http://10.250.80.74:9214/HTTP_Recharge/"
    Rails.logger.info "=========URL================"


    result = "curl -X POST http://10.250.80.74:9214/HTTP_Recharge/ -H \"Content-Type: application/json\" -H \"Authorization: #{jwt_token}\" -d '{\"ProductCode\":\"01\", \"ParameterCode\":\"01\", \"Amount\":\"\", \"TargetMSISDN\":\"244959560801\", \"TransactionReference\":\"1\"}'"
   
    result = `#{result}`
    Rails.logger.info "==============[Result]============================"
    Rails.logger.info result
    Rails.logger.info "=========================================="
=end
  rescue Exception => e
    Rails.logger.info "=========================="
    Rails.logger.info e.message
    Rails.logger.info "=========================="
    Rails.logger.info e.backtrace
    Rails.logger.info "=========================="
    raise "Venda não realizada - #{e.message}"
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
  rescue Exception => e
    Rails.logger.info "=========================="
    Rails.logger.info e.message
    Rails.logger.info "=========================="
    Rails.logger.info e.backtrace
    Rails.logger.info "=========================="
    raise "Verificação de transação não realizada - #{e.message}"
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
end