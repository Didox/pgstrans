class ConsolidadoFinanceiro < ApplicationRecord
    belongs_to :usuario

    def mandar_fila
        sqs_client = Aws::SQS::Client.new(
            credentials: Aws::Credentials.new(AWS_ID, AWS_KEY),
            region: 'us-east-1'
        )

        sqs_client.send_message(
            queue_url: SQS_URL_TOTAIS,
            message_body: "cf_id:#{self.id.to_s}"
        )

        Rails.logger.info "=====[SQS Agendamento Sucesso CF #{DateTime.now}]====="
    end
    
    VENDAS = 1
    CONTA_CORRENTE = 2

    def calcular_valor_total!
        params = JSON.parse(self.parametros) rescue {}
        adm = Usuario.where(id: self.usuario_id).first
        if adm.blank?
            adm.delete
            return
        end

        if self.tipo == ConsolidadoFinanceiro::VENDAS
            params.delete("csv")
            params["usuario_id"] = self.usuario_id
            params["relatorio_job"] = "ok"
            params["ultimo_dado_consolidado"] = "ok"
            params = ActiveSupport::HashWithIndifferentAccess.new(params)

            controller_const = "#{params["controller"]}_controller".camelize.constantize
            controller_const.instance_eval do
                def parametros=(value)
                    @parametros = value
                end

                def parametros
                    @parametros
                end
            end

            controller_const.parametros = params

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

            acao = params["action"]
            dados = controller_const.new.send(acao)
            
            self.valor_total = Venda.total_acesso(adm, dados)
            self.total_lucro = Venda.total_lucros_acesso(adm, dados)
            self.total_custo = Venda.total_custo_acesso(adm, dados)
            self.save!
        else
            self.valor_total = ActiveRecord::Base.connection.exec_query(self.query).first["total"].to_f
            self.save!
        end
    end
end
