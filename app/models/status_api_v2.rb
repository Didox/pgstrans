class StatusApiV2
    def self.translate(status)
        ### cadastrando status no banco
        # traducao = TraducaoApi.where(de: status).first
        # return traducao.para if traducao.present?
        # return status

        case status
        when "200"
            return "PG_200"
        when "340"
            return "PG_555"
        else
            return status
        end
    end
end
