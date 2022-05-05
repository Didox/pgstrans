class Relatorio < ApplicationRecord
    after_create do 
        sqs_client = Aws::SQS::Client.new(
            credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
            region: 'us-east-1'
        )

        sqs_client.send_message(
            queue_url: SQS_URL,
            message_body: self.id.to_s
        )
    end
end
