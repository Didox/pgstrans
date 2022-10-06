namespace :jobs do
  desc "Atualiza token Africell"
  task update_africell_token: :environment do

    Rails.logger.info("==============================")
    Rails.logger.info("Iniciando rake para token africell ...")
    Rails.logger.info("==============================")

    while (true) do
    
      Rails.logger.info("==============================")
      Rails.logger.info("Iniciando troca de token africell ...")
      Rails.logger.info("==============================")

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

        Rails.logger.info("==============================")
        Rails.logger.info("Aguardando a chegada do e-mail lendo dados pela Crontab")
        Rails.logger.info("==============================")

        sleep(30)

        user = Google.user(access_token)
        mensagens = Google.mensagens(user, access_token)

        otp_key = Google.get_otp(mensagens, user, access_token)
        if otp_key.present?

          Rails.logger.info("==============================")
          Rails.logger.info("Atualizado com o OTP key #{otp_key} - Crontab")
          Rails.logger.info("==============================")

          dados["otp_key"] = otp_key
          Parametro.where(id: parametro.id).update_all(dados: dados.to_json)
        else
          Rails.logger.info("==============================")
          Rails.logger.info("Não foi possível ler o email, acesso negado, troque o tokem na área administrativa")
          Rails.logger.info("==============================")
        end
      else
        Rails.logger.info("==============================")
        Rails.logger.info("Refrech token vazio, dados não foram lidos, autentique o usuário na área administrativa")
        Rails.logger.info("==============================")
      end

      Rails.logger.info("==============================")
      Rails.logger.info("Troca de token realizada com sucesso")
      Rails.logger.info("==============================")

      uma_hora = (60*60)

      Rails.logger.info("==============================")
      Rails.logger.info("Aguardando para rodar a proxima hora, previsão para rodar #{(Time.zone.now + uma_hora)}")
      Rails.logger.info("==============================")
      sleep(uma_hora)
    end
  end
end
