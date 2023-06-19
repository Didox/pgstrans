class BantuBet
  require 'openssl'

  def self.parametros
    parceiro = Partner.bantubet
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

  def self.check_client(params)
    # bantu_bet_check_client, parceiro, parametro, url_service = BantuBet.fazer_verifica_cao_cliente # TODO não implementado

    command = "check"
    account = "numero do telefone" ##
    sid = "#{parametro.get.sid}"
    currency = "AOA"
    bt_resource = "#{parametro.get.resource}"
    secret_key = "#{parametro.get.secret_key}"
    payment_id = "#{parametro.get.payment_id}"
    
    hashcode = gerar ##

    url = "#{url_service}/#{parametro.get.endpoint_Transactions}/?command=#{command}&account=#{account}&paymentID=#{payment_id}&currency=#{currency}&sid=#{sid}&hashcode=#{hashcode}"

    uri = URI.parse(URI::Parser.new.escape(url))

    #curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=check&account=946908645&paymentID=3128&currency=AOA&sid=1869146&hashcode=57f6ceec1130226beedb208a78fe32f4'

    request = HTTParty.post(uri, 
    headers: {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{bearer_token_default}",
    },
    body: {
      'command': "#{bearer_token_default}",
      'passphrase': parametro.get.passphrase
    }.to_json,
    timeout: DEFAULT_TIMEOUT.to_i.seconds

    )
    Rails.logger.info "=========================================="
    Rails.logger.info request.inspect
    Rails.logger.info "===================[login]======================="
    Rails.logger.info request.body
    Rails.logger.info "=========================================="
    [BantuBetCheckClient.create(body_request:request.body), parceiro, parametro, url_service]

    return JSON.parse(request.body)
  end

end