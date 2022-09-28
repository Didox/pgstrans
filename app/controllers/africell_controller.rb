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

  def google_auth
    # return
    parceiro, parametro, url_service = Africell.parametros
    refresh_token = parametro.get.google_refresh_token
    if refresh_token.present? 
      access_token = Google.refaz_token(refresh_token)
      return auth(access_token, refresh_token)
    end
  end

  def auth(access_token=nil, refresh_token=nil)
    if access_token.blank? || refresh_token.blank?
      access_token, refresh_token = Google.tokens(params)
    end

    parceiro, parametro, url_service = Africell.parametros
    dados = JSON.parse(parametro.dados)
    dados["google_access_token"] = access_token
    dados["google_refresh_token"] = refresh_token
    parametro.dados = dados.to_json
    parametro.responsavel = usuario_logado
    parametro.save!

    user = Google.user(access_token)
    mensagens = Google.mensagens(user, access_token)

    body_messages = []
    mensagens["messages"] ||= []
    mensagens["messages"].take(5).each do |message|
      messagen_snippet = Google.corpo_mensagem(user, message, access_token)

      snippet = messagen_snippet["snippet"]
      snippet = snippet.to_s.strip

      if snippet.downcase.include?("otp is :")
        otp_key = snippet.scan(/OTP is :.*/).first.gsub(/OTP is :/, "").strip rescue ""
        if otp_key.present?

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
      user: user
    }
  end

end