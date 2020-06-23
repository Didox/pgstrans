namespace :jobs do
  desc "Importa rel ZAPTv"
  task importa_dados_zaptv: :environment do
    partner = Partner.where(slug: "ZAPTv").first
    partner.importa_dados!
  end

  desc "Adiciona grupo rosi"
  task grupo_rosi: :environment do
    usuario = Usuario.where("email = 'rosi.volgarin@gmail.com'").first
    [
      "Produto",
      "Banco",
      "CanalVenda",
      "ContaCorrente",
      "Country",
      "Dispositivo",
      "Industry",
      "Lancamento",
      "MasterProfile",
      "MatrixUser",
      "Moeda",
      "Parametro",
      "Partner",
      "Provincium",
      "Remuneracao",
      "ReturnCodeApi",
      "StatusParceiro",
      "StatusAlegacaoPagamento",
      "StatusCliente",
      "StatusProduto",
      "SubAgente",
      "SubDistribuidor",
      "TipoTransacao",
      "UniPessoalEmpresa",
      "Usuario",
      "Venda",
    ].each do |model|
      model.constantize.all.each do |model|
        model.responsavel = usuario
        model.save
      end
    end
  end

  desc "EXECUTA REST API TEST"
  task importa_produtos_zap: :environment do
    partner = Partner.where(slug: "ZAPTv").first
    partner.importa_produtos!
  end

  desc "Consulta número"
  task consulta_numero_dstv: :environment do
    info = Dstv.informacoes("3001492459")
    debugger

    x = ""
  end

end
