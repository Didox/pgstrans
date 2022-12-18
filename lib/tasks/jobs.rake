namespace :jobs do
  desc "Importa rel ZAPTv"
  task importa_dados_zaptv: :environment do
    partner = Partner.zaptv
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

  desc "Atualiza porcentagem_desconto_venda"
  task atualiza_porcentagem_desconto_venda: :environment do
    puts "=== Iniciando a busca ==="
    Venda.where("porcentagem_desconto is null").limit(500000).each do |venda|
      puts "===[#{venda.id}] | inicio ==="
      desconto_aplicado, valor_original, valor, porcentagem_desconto = Venda.desconto_venda(venda.usuario, venda.partner, venda.valor_original)
      Venda.where(id: venda.id).update_all(porcentagem_desconto: porcentagem_desconto)
      puts "===[#{venda.id}] | fim ==="
    end
  end

  desc "Busca todas as vendas quem não tem registro em conta corrente"
  task atualiza_id_venda_conta_corrente: :environment do
    itens_para_salvar = []
    puts "=== Iniciando a busca de vendas quem não têm registro em conta corrente nos últimos três meses ==="
    Venda.where("created_at > ?", Time.zone.now - 3.months).each do |venda| 
      puts "===[#{venda.id}] | inicio ==="
      if ContaCorrente.where(venda_id: venda.id).count == 0
        if venda.sucesso?
          puts "===[#{venda.id}] | Início ==="
          cc = ContaCorrente.where(usuario_id: usuario.id).first
          if cc.blank?
            banco = Banco.first
            iban = ""
          else
            iban = cc.iban
            banco = cc.banco
          end
    
          banco = Banco.first if banco.blank?
    
          lancamento = Lancamento.where(nome: Lancamento::COMPRA_DE_CREDITO_OU_RECARGA).first
          lancamento = Lancamento.first if lancamento.blank?
    
          conta_corrente = ContaCorrente.new(
            usuario_id: usuario.id,
            valor: "-#{valor}",
            observacao: "Compra de recarga dia #{venda.created_at.strftime("%d/%m/%Y %H:%M:%S")}",
            lancamento_id: lancamento.id,
            banco_id: (banco.id rescue Banco.first.id),
            partner_id: parceiro.id,
            iban: iban,
            venda_id: venda.id,
            created_at:venda.created_at,
            updated_at:venda.created_at,
          )
          conta_corrente.responsavel = usuario

          itens_para_salvar << conta_corrente.to_hash

          #conta_corrente.save!
        end
      end
    end

    File.open("/tmp/conta_correntes_colocar_venda.json", 'w') { |file| itens_para_salvar.to_json }
  end

  desc "zappi_capture"
  task zappi_capture: :environment do
    vendas = Venda.all.where(partner_id: 4).where("zappi is null")
    Rails.logger.info "Total #{vendas.count}"
    vendas.each_with_index do |venda, index|
      zappi = venda.zappi_capture
      if zappi.present?
        Venda.where(id: venda.id).update_all(zappi: zappi)
      end
      Rails.logger.info "#{zappi} - #{index + 1}"
    end
  end

  desc "operation_code"
  task operation_code_capture: :environment do
    vendas = Venda.all.where(partner_id: 4).where("operation_code_zap is null")
    Rails.logger.info "Total #{vendas.count}"
    vendas.each_with_index do |venda, index|
      operation_code_zap = venda.operation_code_zap_capture
      if operation_code_zap.present?
        Venda.where(id: venda.id).update_all(operation_code_zap: operation_code_zap)
      end
      Rails.logger.info "#{operation_code_zap} - #{index + 1}"
    end
  end

  desc "banco export"
  task banco_export: :environment do
    dado = ""
    Banco.all.each_with_index do |cc, index|
      Rails.logger.info index
      dado += "#{cc.to_json}\n"
    end
    File.open("#{Rails.root}/bkp/banco.data", "w") { |f| f.write dado }
  end

  desc "slug lowercase partners"
  task slug_lowercase: :environment do
    Partner.all.each do |partner|
      Partner.where(id: partner.id).update_all(slug: partner.slug.downcase)
    end
  end

  desc "Unificação tabela vendas"
  task unificacao_vendas: :environment do
    parceiro = Partner.find(3) # dstv
    
    PagamentosFaturasDstv.all.each_with_index do |pagamento, i|
      desconto_aplicado, valor_original, valor = Venda.desconto_venda(pagamento.usuario, parceiro, pagamento.valor)
    
      if Venda.where(pagamentos_faturas_dstv_id: pagamento.id).count == 0
        begin
          venda = Venda.new
          venda.desconto_aplicado = desconto_aplicado
          venda.valor_original = valor_original
          venda.value = valor
          venda.request_send = pagamento.request_body
          venda.response_get = pagamento.response_body
          venda.customer_number = pagamento.customer_number
          venda.smartcard = pagamento.smartcard
          venda.receipt_number = pagamento.receipt_number
          venda.transaction_number = pagamento.transaction_number
          venda.status = pagamento.status
          venda.transaction_date_time = pagamento.transaction_date_time
          venda.audit_reference_number = pagamento.audit_reference_number
          venda.created_at = pagamento.created_at
          venda.updated_at = pagamento.updated_at
          venda.usuario_id = pagamento.usuario_id
          venda.lancamento_id = 10 #PAGAMENTO_DE_FATURA
          venda.pagamentos_faturas_dstv_id = pagamento.id
          venda.partner_id = parceiro.id
          venda.responsavel = pagamento.usuario
          venda.save!
        rescue Exception => erro
          x = ""
        end
      end

      Rails.logger.info i
    end

    AlteracoesPlanosDstv.all.each_with_index do |alteracao, i|
      desconto_aplicado, valor_original, valor = Venda.desconto_venda(alteracao.usuario, parceiro, alteracao.valor)
    
      if Venda.where(alteracoes_planos_dstv_id: alteracao.id).count == 0
        begin
          venda = Venda.new
          venda.desconto_aplicado = desconto_aplicado
          venda.valor_original = valor_original
          venda.value = valor
          venda.alteracoes_planos_dstv_id = alteracao.id
          venda.request_send = alteracao.request_body
          venda.response_get = alteracao.response_body
          venda.customer_number = alteracao.customer_number
          venda.smartcard = alteracao.smartcard
          venda.product_nome = alteracao.produto
          venda.codigos_produto = alteracao.codigo
          venda.receipt_number = alteracao.receipt_number
          venda.transaction_number = alteracao.transaction_number
          venda.status = alteracao.status
          venda.transaction_date_time = alteracao.transaction_date_time
          venda.error_message = alteracao.error_message
          venda.audit_reference_number = alteracao.audit_reference_number
          venda.created_at = alteracao.created_at
          venda.updated_at = alteracao.updated_at
          venda.usuario_id = alteracao.usuario_id
          venda.tipo_plano = alteracao.tipo_plano
          venda.lancamento_id = (alteracao.lancamento_id || 12)
          venda.responsavel = alteracao.usuario
          venda.partner_id = parceiro.id
          venda.save!
        rescue Exception => erro
          x = ""
        end
      end

      Rails.logger.info i
    end
  end

  desc "Banco import"
  task banco_import: :environment do
    log_insert = ""

    line_num=0
    text=File.open("#{Rails.root}/bkp/banco.data").read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      Rails.logger.info (line_num += 1)
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
      Rails.logger.info index
      dado += "#{cc.to_json}\n"
    end
    File.open("#{Rails.root}/bkp/conta_corrente.data", "w") { |f| f.write dado }
  end

  desc "Conta corrente import"
  task conta_corrente_import: :environment do
    log_insert = ""
    log_nao_inserido = ""

    line_num=0
    text=File.open("#{Rails.root}/bkp/conta_corrente.data").read
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line|
      begin
        Rails.logger.info (line_num += 1)
        json = JSON.parse(line)
        next if Usuario.where(id: json["usuario_id"]).count == 0

        if ContaCorrente.where(id: json["id"]).count == 0
          responsavel = Usuario.find(json["responsavel_aprovacao_id"]) rescue Usuario.find(2)
          cc = ContaCorrente.new(json)
          cc.responsavel = responsavel
          cc.save!

          log_insert += "#{line}\n"
        end
      rescue Exception => erro
        log_nao_inserido += "#{line} - #{erro.message}"
      end
    end

    File.open("#{Rails.root}/bkp/conta_corrente_insert.log", "w") { |f| f.write log_insert }
    File.open("#{Rails.root}/bkp/conta_corrente_log_nao_inserido.log", "w") { |f| f.write log_nao_inserido }
  end

  desc "Processar loop movicel"
  task processar_loop_movicel: :environment do
    MovicelLoop.where(processar_loop: true).each do |movicel_loop|
      begin
        movicel_loop.processar!
      rescue Exception => err
        Rails.logger.info "==============="
        Rails.logger.info err.mensagem
        Rails.logger.info "==============="
        Rails.logger.info err.backtrace
        Rails.logger.info "==============="
      end
    end
  end

  desc "Insere categoria ZAP (Wifi, TV) em vendas"
  task vendas_categoria: :environment do
    Rails.logger.info "Iniciando update de vendas anteriores a 01/05/2022"
    #Venda.where(partner_id: 4).where("created_at < '2022-05-01 00:00:00'").update_all(categoria: "tv")
    ActiveRecord::Base.connection.exec_query("update vendas set categoria='tv' where partner_id = 4 and created_at < '2022-05-01 00:00:00'")
    Rails.logger.info "Update de vendas anteriores a 01/05/2022 concluído"
    Venda.where(partner_id: 4).where("created_at >= '2022-05-01 00:00:00'").each do |venda|
      Rails.logger.info "=========="
      Rails.logger.info venda.product.description
      Rails.logger.info venda.product.categoria
      Rails.logger.info "=========="
      ActiveRecord::Base.connection.exec_query("update vendas set categoria='#{venda.product.categoria}' where id = #{venda.id}")
    end
  end

  desc "Apaga logs antigos"
  task apaga_logs_antigos: :environment do
    ActiveRecord::Base.connection.exec_query("delete from logs where created_at < '#{(Time.zone.now - 2.months).strftime("%Y-%m-%d %H:%M:%S")}'")
  end

  desc "MigraParametros"
  task migra_parametros: :environment do
    Parametro.all.each do |parametro|
      dados = parametro.attributes
      dados.delete("id")
      dados.delete("partner_id")
      dados.delete("created_at")
      dados.delete("updated_at")

      Parametro.where(id: parametro.id).update_all(dados: dados.to_json)
    end
  end

  desc "Update venda id conta corrente"
  task venda_conta_corrente: :environment do
    puts "=== Iniciando a busca ==="
    ContaCorrente.where("valor < 0").limit(500000).each do |cc|
      puts "===[#{cc.id}] | inicio ==="
      venda = Venda.where(usuario_id: cc.usuario_id, partner_id: cc.partner_id, value: cc.valor.abs)
      venda = venda.where("created_at BETWEEN ? AND ?", SqlDate.sql_parse((cc.created_at - 10.minutes)), SqlDate.sql_parse((cc.created_at)))
      venda = venda.reorder("created_at desc").first
      if venda.present?
        ContaCorrente.where(id: venda.id).update_all(venda_id: venda.id)
      end
      puts "===[#{cc.id}] | Fim ==="
    end
  end

  desc "Cria return code api para zap fibra"
  task return_code_api_zap_fibra: :environment do
    partner_id = Partner.where("lower(slug) = 'zaptv'").first.id
    ReturnCodeApi.where(partner_id:partner_id).each do |ret|
      campos=ret.attributes
      campos.delete("id")
      ret_new=ReturnCodeApi.new(campos)
      ret_new.partner_id = Partner.where("lower(slug) = 'zapfibra'").first.id
      ret_new.responsavel=Usuario.where(email:"rosi.volgarin@gmail.com").first  
      ret_new.save!
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
    partner = Partner.zaptv
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
