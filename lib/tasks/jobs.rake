namespace :jobs do
  desc "Importa rel ZAPTv"
  task importa_dados_zaptv: :environment do
    partner = Partner.where(slug: "ZAPTv").first
    partner.importa_dados!
  end

  desc "Import menu"
  task menu_import: :environment do
    require 'yaml'
    import_menu = YAML.load_file("#{Rails.root}/config/import_menu.yml")
    import_menu.each do |secao, itens|
      itens.each do |nome, controller_action|
        controller, action = controller_action
        menus = Menu.where(secao: secao, nome: nome, controller: controller, action: action)
        if menus.count == 0
          Menu.create(secao: secao, nome: nome, controller: controller, action: action)
        end
      end
    end
  end

  desc "banco export"
  task banco_export: :environment do
    dado = ""
    Banco.all.each_with_index do |cc, index|
      puts index
      dado += "#{cc.to_json}\n"
    end
    File.open("#{Rails.root}/bkp/banco.data", "w") { |f| f.write dado }
  end

  desc "Banco import"
  task banco_import: :environment do
    log_insert = ""

    line_num=0
    text=File.open("#{Rails.root}/bkp/banco.data").read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      puts (line_num += 1)
      json = JSON.parse(line)
      if Banco.where(id: json["id"]).count == 0
        responsavel = Usuario.find(json["responsavel_aprovacao_id"]) rescue Usuario.find(2)
        cc = Banco.new(json)
        cc.responsavel = responsavel
        cc.save!

        log_insert += "#{line}\n"
      end
    end

    File.open("#{Rails.root}/bkp/banco_insert.log", "w") { |f| f.write log_insert }
  end

  desc "Conta corrente export"
  task conta_corrente_export: :environment do
    dado = ""
    ContaCorrente.all.each_with_index do |cc, index|
      puts index
      dado += "#{cc.to_json}\n"
    end
    File.open("#{Rails.root}/bkp/conta_corrente.data", "w") { |f| f.write dado }
  end

  desc "Conta corrente import"
  task conta_corrente_import: :environment do
    log_insert = ""

    line_num=0
    text=File.open("#{Rails.root}/bkp/conta_corrente.data").read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      puts (line_num += 1)
      json = JSON.parse(line)
      next if Usuario.where(id: json["id"]).count = 0

      if ContaCorrente.where(id: json["usuario_id"]).count == 0
        responsavel = Usuario.find(json["responsavel_aprovacao_id"]) rescue Usuario.find(2)
        cc = ContaCorrente.new(json)
        cc.responsavel = responsavel
        cc.save!

        log_insert += "#{line}\n"
      end
    end

    File.open("#{Rails.root}/bkp/conta_corrente_insert.log", "w") { |f| f.write log_insert }
  end

  desc "Processar loop movicel"
  task processar_loop_movicel: :environment do
    MovicelLoop.where(processar_loop: true).each do |movicel_loop|
      begin
        movicel_loop.processar!
      rescue Exception => err
        puts "==============="
        puts err.mensagem
        puts "==============="
        puts err.backtrace
        puts "==============="
      end
    end
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
  
  desc "Atualiza produto nome venda"
  task atualiza_produto_nome_venda: :environment do
    Venda.all.each do |venda|
      product_nome = venda.product.description
      Venda.where(id: venda.id).update_all(product_nome: product_nome)
    end
  end

  desc "Atualiza produto id venda"
  task atualiza_produto_id_venda: :environment do
    Venda.all.each do |venda|
      produto_id_parceiro = venda.product.produto_id_parceiro
      produto_id = venda.product.id
      Venda.where(id: venda.id).update_all(produto_id_parceiro: produto_id_parceiro, product_id: produto_id)
    end
  end

  desc "Atualiza usuario login vazio"
  task atualiza_usuario_login_vazio: :environment do
    Usuario.where("login is null").all.each do |usuario|
      Usuario.where(id: usuario.id).update_all(login: Usuario.gerar_login, senha: "#Fcda#!1133%")
    end
  end
end
