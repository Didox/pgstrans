namespace :relatorios do
  desc "Gera relatorios CSV"
  task csv_partners: :environment do
    Relatorio.where("arquivo is null").each do |rel|
      if rel.partner_id.present?
        partner = Partner.find(rel.partner_id)
        relatorio_conciliacao_zaptvs = PartnersController.show(partner, JSON.parse(rel.parametros))
        #relatorio_conciliacao_zaptvs = relatorio_conciliacao_zaptvs.limit(10)

        @filename = "relatorio_conciliacao_#{partner.slug}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
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

      puts "======[#{url}]======"
    end
  end
end
