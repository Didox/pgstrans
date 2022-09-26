class AfricellController < ApplicationController
  def impressao_recibo
    if params[:target_msisdn].present?
      if params[:target_msisdn][0, 3] != "244"
        numero_africell = "244".to_s + params[:target_msisdn].to_s
      else
        numero_africell = params[:target_msisdn]
      end
      @venda = Venda.where(customer_number: numero_africell, partner_id: Partner.africell.id).first
      flash[:error] = "Nenhuma venda encontrada" if @venda.blank?
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def confirmacao_transacao
    if params[:request_id].present? || params[:target_msisdn].present?
      @retorno_confirmacao = Africell.check_transaction_log(params)
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def auth
    code = params[:code]
    client_id = "78799946860-j3cbcbraeqp1227gnff4b7g00tbaahpa.apps.googleusercontent.com"
    client_secret = "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"
    
    dados = "code=#{code}&client_id=#{client_id}&client_secret=#{client_secret}&grant_type=authorization_code&redirect_uri=http://localhost:3000/africell/auth"
          
    url = URI("https://oauth2.googleapis.com/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = dados
    response = http.request(request)

    json = JSON.parse(response.read_body)
    access_token = json["access_token"]

    url_user = "https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=#{access_token}"
    url = URI(url_user)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    user = JSON.parse(response.read_body)


    url_mensagens = "https://gmail.googleapis.com/gmail/v1/users/#{user["id"]}/messages?labelIds=INBOX&q=Africell Recharge GW (Prod) OTP&access_token=#{access_token}"
    url = URI(url_mensagens)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    mensagens = JSON.parse(response.read_body)

    body_messages = []
    mensagens["messages"] ||= []
    mensagens["messages"].take(5).each do |message|
      url_message = "https://gmail.googleapis.com/gmail/v1/users/#{user["id"]}/messages/#{message["id"]}?access_token=#{access_token}"
      url = URI(url_message)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      messagen_snippet = JSON.parse(response.read_body)

      snippet = messagen_snippet["snippet"]
      snippet = snippet.to_s.strip

      if snippet.downcase.include?("otp is :")
        otp_key = snippet.scan(/OTP is :.*/).first.gsub(/OTP is :/, "").strip rescue ""
        if otp_key.present?

          parceiro, parametro, url_service = Africell.parametros

          dados = JSON.parse(parametro.dados)
          dados["otp_key"] = otp_key
          parametro.dados = dados.to_json
          parametro.responsavel = usuario_logado
          parametro.save!

          return redirect_to partner_url(parceiro)

          return render json: {
            otp_key: otp_key
          }
        end
      end

     

      body_messages << snippet
    end

    render json: {
      access_token: access_token,
      url: url_user,
      user: user,
      auth: json,
      body_messages: body_messages
    }
  end

end