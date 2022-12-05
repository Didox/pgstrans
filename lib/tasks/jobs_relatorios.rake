namespace :relatorios do
  desc "Gera relatorios CSV"
  task csv_partners: :environment do
    Relatorio.where("arquivo is null").each do |rel|
      if rel.partner_id.present?
        partner = Partner.find(rel.partner_id)
        relatorio_conciliacao_zaptvs = PartnersController.show(partner, JSON.parse(rel.parametros))
        #relatorio_conciliacao_zaptvs = relatorio_conciliacao_zaptvs.limit(10)

        @filename = "relatorio_conciliacao_#{partner.slug}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
        File.write("/tmp/#{filename}", relatorio_conciliacao_zaptvs.to_csv)
      else
        controller, acao = rel.controller_acao.split("::")
        dados = controller.constantize.new.send("#{acao}_relatorio", JSON.parse(rel.parametros))

        @filename = "relatorio-#{controller}-#{acao}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
        File.write("/tmp/#{@filename}", dados.to_csv)
      end

      url = AwsService.upload("/tmp/#{@filename}", @filename) 
      rel.arquivo = url
      rel.save!
    end
  end
end
