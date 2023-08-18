class Relatorio < ApplicationRecord
    def envia_sqs 
        sqs_client = Aws::SQS::Client.new(
            credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
            region: 'us-east-1'
        )

        sqs_client.send_message(
            queue_url: SQS_URL,
            message_body: "relatorio_id:#{self.id.to_s}"
        )

        Rails.logger.info "=====[SQS Agendamento Sucesso #{DateTime.now}]====="
    end
end
