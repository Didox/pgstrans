namespace :sqs do
  desc "Consome mensagens SQS"
  task consumer: :environment do
    sqs_client = Aws::SQS::Client.new(
        credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
        region: 'us-east-1'
    )

    while (true)
      Rails.logger.info "#{Time.zone.now.strftime("%Y%m%d%H%M%S")} - lendo ..."
      receive_message_result = sqs_client.receive_message({
        queue_url: SQS_URL, 
        message_attribute_names: ["All"], # Receive all custom attributes.
        max_number_of_messages: 1, # Receive at most one message.
        wait_time_seconds: 20 # Do not wait to check for the message.
      })

      receive_message_result.messages.each do |message|
        begin
          Rails.logger.info "#{Time.zone.now.strftime("%Y%m%d%H%M%S")} - Importando ..."
          if message.body.to_s.include?("relatorio_id:")
            relatorio_id = message.body.gsub("relatorio_id:", "")
            rel = Relatorio.where(id: relatorio_id).where("arquivo is null").first
            if rel.blank?
              sqs_client.delete_message({
                queue_url: SQS_URL,
                receipt_handle: message.receipt_handle    
              })
              next
            end

            if rel.partner_id.present?
              partner = Partner.find(rel.partner_id)
              parametros = OpenStruct.new(JSON.parse(rel.parametros))
              relatorio_conciliacao_zaptvs = PartnersController.show(partner, parametros)
              #relatorio_conciliacao_zaptvs = relatorio_conciliacao_zaptvs.limit(10)
      
              @filename = "relatorio_conciliacao_#{partner.slug}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}-#{parametros[:categoria]}.csv"
              File.write("/tmp/#{@filename}", relatorio_conciliacao_zaptvs.to_csv)
            else
              controller, acao = rel.controller_acao.split("::")
              parametros = JSON.parse(rel.parametros)
              parametros.delete("csv")
              parametros["usuario_id"] = rel.usuario_id
              parametros["relatorio_job"] = "ok"
              parametros = ActiveSupport::HashWithIndifferentAccess.new(parametros)

              controller_const = controller.constantize
              controller_const.instance_eval do
                def parametros=(value)
                  @parametros = value
                end

                def parametros
                  @parametros
                end
              end

              controller_const.parametros = parametros

              controller_const.class_eval do
                def administrador
                  @adm = Usuario.find(self.class.parametros["usuario_id"])
                  self.class.parametros.delete("usuario_id")
                  @adm
                end
                def params
                  self.class.parametros
                end
              end
              dados = controller_const.new.send(acao)

              @filename = "relatorio-#{controller}-#{acao}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
              File.write("/tmp/#{@filename}", dados.to_csv)
            end
      
            url = AwsService.upload("/tmp/#{@filename}", @filename) 
            rel.arquivo = url
            rel.save!

            sqs_client.delete_message({
              queue_url: SQS_URL,
              receipt_handle: message.receipt_handle    
            })

            AdmMailer.notifica_csv_processado(rel).deliver

            `echo "=====[SQS #{DateTime.now} Sucesso]=====" >> log/#{Rails.env}.log`
            `echo "#{url}" >> log/#{Rails.env}.log`
            `echo "=======================================" >> log/#{Rails.env}.log`
          elsif message.body.to_s.include?("cf_id:")
            cf_id = message.body.gsub("cf_id:", "")
            ConsolidadoFinanceiro.where(id: cf_id).each do |item|
              item.calcular_valor_total!
            end
          else
            sqs_client.delete_message({
              queue_url: SQS_URL,
              receipt_handle: message.receipt_handle    
            })
          end

        rescue Exception => e
          Rails.logger.info e.message
          Rails.logger.info e.backtrace

          `echo "=====[SQS #{DateTime.now} Erro]=====" >> log/#{Rails.env}.log`
          `echo "#{e.message},  #{e.backtrace}" >> log/#{Rails.env}.log`
          `echo "====================================" >> log/#{Rails.env}.log`
        end
      end
    end
  end
end
