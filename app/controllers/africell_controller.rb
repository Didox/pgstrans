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
    update_parametros(access_token, refresh_token, parametro)

    user = Google.user(access_token)
    mensagens = Google.mensagens(user, access_token)

    otp_key = Google.get_otp(mensagens, user, access_token)
    if otp_key.present?

      Rails.logger.info("==============================")
      Rails.logger.info("Aguardando a chegada do e-mail")
      Rails.logger.info("==============================")
      sleep(30)

      dados = JSON.parse(parametro.dados)
      dados["otp_key"] = otp_key
      parametro.dados = dados.to_json
      parametro.responsavel = usuario_logado
      parametro.save!

      flash[:notice] = 'Transação de login na plataforma Africell concluída com sucesso.'
      
      return redirect_to partner_url(parceiro)
    end

    flash[:error] = 'Google não autorizou a leitura do email, refaça o login.'

    update_parametros(nil, nil, parametro)
    return redirect_to "/google-auth"
  end

  def update_parametros(access_token, refresh_token, parametro)
    dados = JSON.parse(parametro.dados)
    dados["google_access_token"] = access_token
    dados["google_refresh_token"] = refresh_token
    parametro.dados = dados.to_json
    parametro.responsavel = usuario_logado
    parametro.save!
  end

end