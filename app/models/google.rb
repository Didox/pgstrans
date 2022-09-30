class Google
  def self.tokens(params)
    code = params[:code]

    client_id = GOOGLE_CLIENT_ID
    client_secret = GOOGLE_SECRET
    
    dados = "code=#{code}&client_id=#{client_id}&client_secret=#{client_secret}&grant_type=authorization_code&redirect_uri=#{GOOGLE_URL_RETORNO}"
          
    url = URI("https://oauth2.googleapis.com/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = dados
    response = http.request(request)

    json = JSON.parse(response.read_body)
    
    [json["access_token"], json["refresh_token"]]
  end

  def self.refaz_token(refresh_token)
    url = URI("https://www.googleapis.com/oauth2/v4/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    dados = {
      refresh_token: refresh_token,
      grant_type: "refresh_token",
      client_id: GOOGLE_CLIENT_ID,
      client_secret: GOOGLE_SECRET
    }
  
    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/json'
    request.body = dados.to_json
    response = http.request(request)
    dado = JSON.parse(response.read_body)
    dado["access_token"]
  rescue
    nil
  end


  def self.corpo_mensagem(user, message, access_token)
    url_message = "https://gmail.googleapis.com/gmail/v1/users/#{user["id"]}/messages/#{message["id"]}?access_token=#{access_token}"
    url = URI(url_message)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
  end

  def self.mensagens(user, access_token)
    url_mensagens = "https://gmail.googleapis.com/gmail/v1/users/#{user["id"]}/messages?labelIds=INBOX&q=Africell Recharge GW (Prod) OTP&access_token=#{access_token}"
    url = URI(url_mensagens)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    JSON.parse(response.read_body)
  end

  def self.user(access_token)
    url_user = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{access_token}"
    url = URI(url_user)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    JSON.parse(response.read_body)
  end

end