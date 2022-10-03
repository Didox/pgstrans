namespace :jobs do
  desc "Atualiza token Africell"
  task update_africell_token: :environment do
    
    Africell.login
    Africell.refresh_token(true)

    parceiro, parametro, url_service = Africell.parametros
    refresh_token = parametro.get.google_refresh_token
    if refresh_token.present? 
      access_token = Google.refaz_token(refresh_token)
      
      dados = JSON.parse(parametro.dados)
      dados["google_access_token"] = access_token
      dados["google_refresh_token"] = refresh_token
      Parametro.where(id: parametro.id).update_all(dados: dados.to_json)

      user = Google.user(access_token)
      mensagens = Google.mensagens(user, access_token)

      otp_key = Google.get_otp(mensagens, user, access_token)
      if otp_key.present?
        dados = JSON.parse(parametro.dados)
        dados["otp_key"] = otp_key
        parametro.dados = dados.to_json
        parametro.responsavel = usuario_logado
        parametro.save!
      end
      
    end
  end
end
