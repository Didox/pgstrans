class ElephantBet
  require 'openssl'

  def self.parametros
    parceiro = Partner.elephantbet
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

  def self.consultar_voucher_reference(transaction_reference)
    elephant_bet_login, parceiro, parametro, url_service = ElephantBet.login

    bearer_token_default = "#{parametro.get.bearer_token_default}"

    sessao = JSON.parse(elephant_bet_login.body_request)
    session_id = sessao["loginInformation"]["session"]

    raise PagasoError.new("Sessão expirada") if session_id.blank?

    url = "#{url_service}/#{parametro.get.endpoint_HTTP_ConsultaVoucher}/#{transaction_reference}?session=#{session_id}"
    uri = URI.parse(URI::Parser.new.escape(url))

    request = HTTParty.get(uri, 
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{bearer_token_default}",
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    return JSON.parse(request.body)
  end

  def self.consultar_voucher_payment_code(payment_code)
    consultar_voucher_reference(payment_code)
  end
  
  def self.login
    parceiro, parametro, url_service = self.parametros
    url = "#{url_service}/#{parametro.get.endpoint_HTTP_Login}"
    uri = URI.parse(URI::Parser.new.escape(url))

    bearer_token_default = "#{parametro.get.bearer_token_default}"

    request = HTTParty.post(uri, 
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{bearer_token_default}",
      },
      body: {
        'login': parametro.get.login,
        'passphrase': parametro.get.passphrase
      }.to_json,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "===================[login]======================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="
    [ElephantBetLogin.create(body_request:request.body), parceiro, parametro, url_service]
  end

end