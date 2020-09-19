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

  desc "Consulta número"
  task atualiza_vendas_desconto: :environment do
    Venda.all.each do |venda|
      desconto_aplicado, valor_original, valor = Venda.desconto_venda(venda.usuario, venda.partner, venda.value)
      Venda.where(id: venda.id).update_all(value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original)
    end
  end
  
  desc "Correção numero"
  task atualiza_vendas_desconto_correcao: :environment do
    Venda.where("created_at > ?", Time.zone.now - 15.days).each do |venda|
      venda_value = venda.product.valor_compra_site || 0
      desconto_aplicado, valor_original, valor = Venda.desconto_venda(venda.usuario, venda.partner, venda_value)
      Venda.where(id: venda.id).update_all(value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original)
    end
  end

end
