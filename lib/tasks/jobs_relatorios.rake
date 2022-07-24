namespace :relatorios do
  desc "Gera CSV partner"
  task csv_partners: :environment do
    Relatorio.where("partner_id is not null and arquivo is null").each do |rel|
      partner = Partner.find(rel.partner_id)
      relatorio_conciliacao_zaptvs = PartnersController.show(partner, JSON.parse(rel.parametros))
      #relatorio_conciliacao_zaptvs = relatorio_conciliacao_zaptvs.limit(10)

      filename = "relatorio_conciliacao_#{partner.slug}-#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.csv"
      File.write("/tmp/#{filename}", relatorio_conciliacao_zaptvs.to_csv)

      url = AwsService.upload("/tmp/#{filename}", filename) 
      rel.arquivo = url
      rel.save!
    end
  end
end
