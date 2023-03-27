class ProxyPay
  require 'openssl'

  def self.parametros
    parceiro = Partner.proxypay
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?

    if Rails.env == "development"
      url_service = parametro.get.url_api_integracao_desenvolvimento
    else
      url_service = parametro.get.url_api_integracao_producao
    end

    [parceiro,parametro,url_service]
  end

  def self.gerar_referencia(transaction_reference)
    parceiro, parametro, url_service = self.parametros

    api_key_desenvolvimento = "#{parametro.get.api_key_desenvolvimento}"

    url = "#{url_service}/#{parametro.get.endpoint_HTTP_Create_Update_Delete_Reference}/#{transaction_reference}"
    uri = URI.parse(URI::Parser.new.escape(url))

    request = HTTParty.put(uri, 
      headers: {
        'Content-Type' => 'application/vnd.proxypay.v2+json',
        'Authorization' => "Token #{api_key_desenvolvimento}",
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    return (200..299).include?(request.code)
  end

  def self.consultar_voucher_payment_code(payment_code)
    consultar_voucher_reference(payment_code)
  end

end