class Relatorio < ApplicationRecord
    # after_create: envia_sns

    def envia_sns
        sqs_client = Aws::SQS::Client.new(
            credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
            region: 'us-east-1'
        )

        sqs_client.send_message(
            queue_url: "https://sqs.us-east-1.amazonaws.com/621964606260/RelatoriosCSVPagaso",
            message_body: "oi rosi"
        )
    end
end
