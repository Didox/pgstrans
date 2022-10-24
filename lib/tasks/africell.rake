namespace :jobs do
  desc "Atualiza token Africell"
  task update_africell_token: :environment do

    Rails.logger.info("==============================================")
    Rails.logger.info("Iniciando rake para refresh token africell ...")
    Rails.logger.info("==============================================")

    while (true) do
      Rails.logger.info("==============================")
      Rails.logger.info("Iniciando troca de token africell ...")
      Rails.logger.info("==============================")

      begin
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

          Rails.logger.info("=================================================================")
          Rails.logger.info("Parada de 120 segundos para aguardar a chegada do e-mail - Crontab")
          Rails.logger.info("=================================================================")

          sleep(120)

          user = Google.user(access_token)
          mensagens = Google.mensagens(user, access_token)

          otp_key = Google.get_otp(mensagens, user, access_token)
          if otp_key.present?

            Rails.logger.info("==================================================================================")
            Rails.logger.info("Parâmetros de integração atualizados com o novo OTP key #{otp_key} - Crontab")
            Rails.logger.info("==================================================================================")

            dados["otp_key"] = otp_key
            dados["otp_key_data_atualizacao_rake"] = Time.zone.now
            Parametro.where(id: parametro.id).update_all(dados: dados.to_json)
            OtpKeyAfricellLog.create(log: "Último OTP_KEY lido e atualizado nos parâmetros de integração pela tarefa robot: #{otp_key}", data: Time.zone.now)

            begin
              mensagem = "Último OTP_KEY lido e atualizado nos parâmetros de integração pela tarefa robot : #{otp_key} - #{Time.zone.now}"
              AdmMailer.send_otp_token_log(mensagem, mensagem).deliver
            rescue Exception => erro
              Rails.logger.info("Erro ao enviar email OTP Key - #{erro.message} - #{erro.backtrace}")
            end
          else
            mensagem = "Não foi possível ler o email. Acesso negado! Altere o token nos Parâmetros de Integração da Africell."

            Rails.logger.info("=====================================================================================================")
            Rails.logger.info(mensagem)
            Rails.logger.info("=====================================================================================================")

            begin
              AdmMailer.send_otp_token_log(mensagem, mensagem).deliver
            rescue Exception => erro
              Rails.logger.info("Erro ao enviar email OTP Key - #{erro.message} - #{mensagem} - #{erro.backtrace}")
            end
          end
        else
          mensagem = "Refresh token vazio. Os dados não foram lidos. Autentique o usuário na Área Administrativa/Backoffice"

          Rails.logger.info("=====================================================================================================")
          Rails.logger.info(mensagem)
          Rails.logger.info("=====================================================================================================")

          begin
            AdmMailer.send_otp_token_log(mensagem, mensagem).deliver
          rescue Exception => erro
            Rails.logger.info("Erro ao enviar email OTP Key - #{erro.message} - #{mensagem} - #{erro.backtrace}")
          end
        end

        Rails.logger.info("=====================================")
        Rails.logger.info("Troca de token realizada com sucesso!")
        Rails.logger.info("=====================================")

        uma_hora = (60*60)

        Rails.logger.info("=======================================================================================================")
        Rails.logger.info("Aguardando a próxima hora para fazer nova autalização. Previsão para a próxima atualização #{(Time.zone.now + uma_hora)}")
        Rails.logger.info("=======================================================================================================")
        sleep(uma_hora)
      rescue Exception => erro
        Rails.logger.info("====================================================================")
        Rails.logger.info("Erro ao executar tarefa OTP Key - #{Time.zone.now} - Timeout - Fazendo nova tentantiva - #{erro.message} - #{erro.backtrace}")
        Rails.logger.info("====================================================================")
        um_minuto = 60
        sleep(um_minuto)
      end
    end
  end
end
