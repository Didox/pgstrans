namespace :signature do
    desc "Generate signature"

    task :generate do
      require 'json'
      require 'openssl'
      require 'base64'
  

      data = {"amount":"1000.00","custom_fields":{},"datetime":"2023-07-25T09:30:26Z","entity_id":1166,"fee":"0.00","id":753904015866,"parameter_id":0,"period_end_datetime":"2023-07-25T19:00:00Z","period_id":7539,"period_start_datetime":"2023-07-24T19:00:00Z","product_id":1,"reference_id":938849107,"terminal_id":"0000140555","terminal_location":"Benguela","terminal_period_id":73,"terminal_transaction_id":160,"terminal_type":"ATM","transaction_id":4015866}
      
      api_key = "???? colocar aqui ????"

      http_body = data.to_json
      x_signature = "bf556ec5a13b68e2e2073155e6255889095d166bd333e5264ebeb9393b28fe13"
  
      signature = generate_signature(api_key, http_body)
  
      puts "A assinatura passada é: #{x_signature}"
      puts "A assinatura gerada é: #{signature}"

      puts "Comparacao: #{signature == x_signature}"

    end
  end
  
  def generate_signature(api_key, json_body)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), api_key, json_body)
  end