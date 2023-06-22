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

  def self.busca_nome(telefone)
    parceiro = Partner.bantubet
    parametro = Parametro.where(partner_id: parceiro.id).first
    
    command = "check"
    account = telefone
    sid = "#{parametro.get.sid}"
    currency = "AOA"
    bt_resource = "#{parametro.get.resource}"
    secret_key = "#{parametro.get.secret_key}"
    payment_id = "#{parametro.get.payment_id}"
    
    require 'digest'
    hashcode = Digest::MD5.new.hexdigest("#{command}#{account}#{currency}#{sid}#{parametro.get.secret_key}")
    
    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
    end

    url = "#{url_service}/#{parametro.get.endpoint_Transactions}/#{bt_resource}/?command=#{command}&account=#{account}&paymentID=#{payment_id}&currency=#{currency}&sid=#{sid}&hashcode=#{hashcode}"

    uri = URI.parse(URI::Parser.new.escape(url))

    request = HTTParty.post(uri, 
      headers: {
        'Content-Type' => 'application/json'
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    user = JSON.parse(request.body)["response"] rescue {}

    return "Cliente não encontrado na operadora" if user.blank?
    
    return "#{user["FirstName"]} #{user["LastName"]}"
  end

end