class ConsolidadoFinanceiro < ApplicationRecord
    belongs_to :usuario
    
    VENDAS = 1
    CONTA_CORRENTE = 2

    def calcular_valor_total
        params = JSON.parse(self.parametros)
        adm = Usuario.find(self.usuario_id)

        if self.tipo == ConsolidadoFinanceiro::VENDAS
            params.delete("csv")
            params["usuario_id"] = self.usuario_id
            params["relatorio_job"] = "ok"
            params = ActiveSupport::HashWithIndifferentAccess.new(params)

            controller_const = controller.constantize
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
                # perfil "Financeiro"
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
            
            self.valor_total = number_to_currency(Venda.total_acesso(adm, dados), :unit => "KZ")
            self.total_lucro = number_to_currency(Venda.total_lucros_acesso(adm, dados), :unit => "KZ")
            self.total_custo = number_to_currency(Venda.total_custo_acesso(adm, dados), :unit => "KZ")
            self.save
        else
            puts "... conta corrente"
        end
    end
end
