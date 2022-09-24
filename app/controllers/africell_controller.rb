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

    render json: {
      access_token: access_token,
      url: url_user,
      user: JSON.parse(response.read_body),
      auth: json
    }
  end

end