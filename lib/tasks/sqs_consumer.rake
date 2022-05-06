namespace :sqs do
  desc "Consome mensagens SQS"
  task consumer: :environment do
    sqs_client = Aws::SQS::Client.new(
        credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
        region: 'us-east-1'
    )

    while (true)
      puts "lendo ..."
      receive_message_result = sqs_client.receive_message({
        queue_url: SQS_URL, 
        message_attribute_names: ["All"], # Receive all custom attributes.
        max_number_of_messages: 1, # Receive at most one message.
        wait_time_seconds: 20 # Do not wait to check for the message.
      })

      receive_message_result.messages.each do |message|
        sqs_client.delete_message({
          queue_url: SQS_URL,
          receipt_handle: message.receipt_handle    
        })

        begin
          puts "Importando ..."
          relatorio_id = message.body
          rel = Relatorio.where(id: relatorio_id).first
          next if rel.blank?
          partner = Partner.find(rel.partner_id)
          relatorio_conciliacao_zaptvs = PartnersController.show(partner, JSON.parse(rel.parametros))
          #relatorio_conciliacao_zaptvs = relatorio_conciliacao_zaptvs.limit(10)
    
          filename = "relatorio_conciliacao_#{partner.slug}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
          File.write("/tmp/#{filename}", relatorio_conciliacao_zaptvs.to_csv)
    
          url = AwsService.upload("/tmp/#{filename}", filename) 
          rel.arquivo = url
          rel.save!

          puts url

          `echo "=====[SQS #{DateTime.now} Sucesso]=====" >> log/#{Rails.env}.log`
          `echo "#{url}" >> log/#{Rails.env}.log`
          `echo "=======================================" >> log/#{Rails.env}.log`

          AdmMailer.notifica_csv_processado(rel).deliver
        rescue Exception => err
          puts e.message
          puts e.stacktrace

          `echo "=====[SQS #{DateTime.now} Erro]=====" >> log/#{Rails.env}.log`
          `echo "#{e.message},  #{e.stacktrace}" >> log/#{Rails.env}.log`
          `echo "====================================" >> log/#{Rails.env}.log`
        end
      end
    end
  end
end
