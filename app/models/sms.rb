class Sms
  def self.enviar(numero, mensagem)
    uri = URI.parse(URI::Parser.new.escape(URL_SMS))
    request = HTTParty.post(uri,
      :body => {
        ApiKey: API_KEY_SMS,
        Destino: [numero],
        Mensagem: mensagem,
        CEspeciais: 'false'
      }
    )
    
    retorno = JSON.parse(request.body)
    return [retorno["Exito"], retorno]
  rescue Exception => err
    return [false, err]
  end
end
