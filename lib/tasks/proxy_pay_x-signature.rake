namespace :signature do
    desc "Generate signature"

    task :generate do
      file_path = Rails.public_path.join("log_proxy_pay_x-signature-1683814651.json")
  
      unless File.exist?(file_path)
        puts "O arquivo #{file_name} não existe."
        exit
      end
  
      require 'json'
      require 'openssl'
      require 'base64'
  
      file_content = File.read(file_path)
      data = JSON.parse(file_content)
  
      api_key = data['api_key']
      http_body = data['http_body']
      x_signature = data['x_signature']
  
      signature = generate_signature(api_key, http_body)
  
      puts "A assinatura passada é: #{x_signature}"
      puts "A assinatura gerada é: #{signature}"
    end
  end
  
  def generate_signature(api_key, http_body)
    digest = OpenSSL::Digest.new('sha256')
    hmac = OpenSSL::HMAC.digest(digest, api_key, http_body)
    signature = Base64.strict_encode64(hmac)
  
    return signature
  end