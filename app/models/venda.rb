class Venda < ApplicationRecord
  include PermissionamentoDados
  default_scope { order(created_at: :desc) }
  belongs_to :usuario
  belongs_to :lancamento, optional: true
  belongs_to :partner

  after_save :update_product, :atualizar_vendas_consolidadas

  def movimentacoes_conta_corrente
    ccs = ContaCorrente.where(venda_id: self.id)
    return ccs.first if ccs.count > 0

    ccs = ContaCorrente.where(valor: "-#{self.value}", partner_id: self.partner_id, usuario_id: self.usuario_id)
    ccs = ccs.where("created_at > ? ", self.created_at).limit(1)
    cc = ccs.reorder("created_at asc").first
    cc
  rescue
    nil
  end
  
  def destroy
    raise PagasoError.new("Registro de Venda não pode ser excluído")
  end

  def self.destroy_all
    raise PagasoError.new("Registro de Venda não pode ser excluído")
  end

  def self.to_csv
    attributes = "ID Venda, Usuário, Nome do Parceiro, Categoria, Data da Venda, Situação da Venda, Produto ID Parceiro, Produto ID Pagaso, Nome do Produto, Customer Number, Smartcard, Valor Face, Desconto, Porcentagem Desconto, Lucro".split(",")

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |venda|
        if venda.porcentagem_desconto.present?
          porcentagem = venda.porcentagem_desconto.to_f
        else
          porcentagem = (venda.desconto_aplicado.to_f / venda.valor_original.to_f * 100) 
          porcentagem = porcentagem.nan? ? 0 : porcentagem.round(2)
        end

        csv << [
          venda.id,
          venda.usuario.nome,
          venda.partner.name,
          venda.categoria,
          venda.created_at.strftime("%d/%m/%Y %H:%M"),
          venda.status_desc.error_description_pt,
          venda.produto_id_parceiro,
          venda.product_id,
          venda.product_nome,
          venda.customer_number,
          venda.smartcard,
          moeda_csv(helper.number_to_currency(venda.valor_original.to_f, :unit => "")),
          moeda_csv(helper.number_to_currency(venda.desconto_aplicado.to_f, :unit => "")),
          moeda_csv(helper.number_to_currency(porcentagem.to_f, :unit => "")),
          moeda_csv(helper.number_to_currency(venda.value.to_f, :unit => "")),
        ]
      end
    end
  end
  
  def operation_code_zap_capture
    JSON.parse(self.response_get)["operation_code"]
  rescue
    ""
  end

  def update_product
    if self.product.present? && self.product_nome.blank?
      Venda.where(id: self.id).update_all(product_nome: self.product.description, product_id: self.product.id)
    end

    if self.zappi.blank?
      Venda.where(id: self.id).update_all(zappi: self.zappi_capture)
    end

    if self.operation_code_zap.blank?
      Venda.where(id: self.id).update_all(operation_code_zap: self.operation_code_zap_capture)
    end
  end

  def product
    produto = Produto.produtos.where(partner_id: self.partner_id).where(produto_id_parceiro: self.produto_id_parceiro).first
    produto ||= Produto.produtos.where(partner_id: self.partner_id).where(id: self.product_id).first
    return produto || Produto.new
  rescue
    Produto.new
  end

  def request_send_parse
    JSON.parse(self.request_send.gsub(/\n|\t/, ""))
  end

  def response_get_parse
    JSON.parse(self.response_get.gsub(/\n|\t/, ""))
  rescue
    {}
  end

  def status_desc
    if self.status.present?
      return_code = ReturnCodeApi.where(return_code: self.status, partner_id: self.partner_id).first 
      return return_code if return_code.present?
    end

    if self.message_api_terceiro.present?
      return_code = ReturnCodeApi.where("error_description ilike ?", "%#{self.message_api_terceiro_para_busca}%").where(partner_id: self.partner_id).first 
      return return_code if return_code.present?
    end

    mensagem = "Status não localizado ou sem resposta da operadora"

    return_code = ReturnCodeApi.where("error_description ilike ?", "%#{mensagem}%").where(partner_id: self.partner_id).first 
    if return_code.present?
      return return_code if return_code.present?
    end

    mensagem = self.message_api_terceiro if self.message_api_terceiro.present?

    return ReturnCodeApi.new(error_description_pt: mensagem)
  rescue Exception => erro
    return ReturnCodeApi.new(error_description_pt: erro.message)
  end

  def self.total(usuario_logado, vendas_filtrada=nil)
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.all
    end
    vendas = vendas.where(status: ReturnCodeApi.all.map{|r| r.return_code } )
    vendas = vendas.where(usuario_id: usuario_logado.id)
    vendas.sum(:value)
  end

  def self.total_acesso(usuario_logado, vendas_filtrada=nil)
    total_acesso_geral(usuario_logado, :valor_original, vendas_filtrada)
  end

  def self.total_lucros_acesso(usuario_logado, vendas_filtrada=nil)
    total_acesso_geral(usuario_logado, :desconto_aplicado, vendas_filtrada)
  end

  def self.total_custo_acesso(usuario_logado, vendas_filtrada=nil)
    total_acesso_geral(usuario_logado, :value, vendas_filtrada)
  end

  def self.total_acesso_geral(usuario_logado, coluna, vendas_filtrada=nil)
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.com_acesso(usuario_logado)
    end
    vendas = vendas.where(status: ReturnCodeApi.all.map{|r| r.return_code } )
    vendas.sum(coluna)
  end

  def sucesso?
    ReturnCodeApi.where(return_code: self.status, sucesso: true, partner_id: self.partner_id).count > 0
  end

  def self.fazer_venda(params, usuario, slug_parceiro, ip)
    slug_parceiro = slug_parceiro.downcase.strip
    venda = self.send("venda_#{slug_parceiro}", params, usuario, ip)
    return Venda.new if venda.blank?
    return venda
  end

  def request_id
    if super.present?
      return super
    end

    self.response_get.scan(/RequestId.*?RequestId>/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue ""
  end

  def carregamento_venda_zaptv
    parceiro = Partner.zaptv
    parametro = Parametro.where(partner_id: parceiro.id).first
    if Rails.env == "development"
      url = "#{parametro.get.url_integracao_desenvolvimento}/#{self.request_id}"
      api_key = parametro.get.api_key_zaptv_desenvolvimento
    else
      url = "#{parametro.get.url_integracao_producao}/#{self.request_id}"
      api_key = parametro.get.api_key_zaptv_producao
    end

    begin
      if self.request_id.present?
        res = HTTParty.get(
          url, 
          headers: {
            "apikey" => api_key,
            "Content-Type" => "application/json"
          }, timeout: DEFAULT_TIMEOUT.to_i.seconds
        )

        if (200..300).include?(res.code)
          self.status = "7000"
          self.save!
          return "sucesso"
        else
          return "Delete in (#{url}) - #{res.body}"
        end
      end

      return "Código de operação ZAPTV não encontrado"
    rescue Exception => err
      return "GET in (#{url}) - #{err.message}"
    end
  end

  def reverter_venda_zaptv
    parceiro = Partner.zaptv
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url = "#{parametro.get.url_integracao_desenvolvimento}/#{self.request_id}"
      api_key = parametro.get.api_key_zaptv_desenvolvimento
    else
      url = "#{parametro.get.url_integracao_producao}/#{self.request_id}"
      api_key = parametro.get.api_key_zaptv_producao
    end

    if parametro.get.categoria.downcase == "wifi"
      host = host.gsub("/carregamento",'/reversao')
    end

    begin
      if self.request_id.present?
        res = HTTParty.delete(
          url, 
          headers: {
            "apikey" => api_key,
            "Content-Type" => "application/json"
          }, timeout: DEFAULT_TIMEOUT.to_i.seconds
        )

        if (200..300).include?(res.code)
          Venda.where(id: self.id).update_all(status: "7000")
          return "sucesso"
        else
          return "Delete in (#{url}) - #{res.body}"
        end
      end

      return "Código de operação ZAPTV não encontrado"
    rescue Exception => err
      return "Delete in (#{url}) - #{err.message}"
    end
  end

  def zappi_capture
    json = self.request_send.include?("body=") ? self.request_send.split("body=")[1] : self.request_send
    JSON.parse(json)["zappi"]
  rescue
    ""
  end

  def operation_code_capture
    JSON.parse(self.response_get)["operation_code"]
  rescue
    ""
  end

  def self.desconto_venda(usuario, parceiro, valor)
    if parceiro.present?
      desconto = 0
      remuneracoes = Remuneracao.where(usuario_id: usuario.id, ativo: true)

      if remuneracoes.count > 0
        remuneracao = remuneracoes.first
        if remuneracao.present?
          remuneracao_descontos = RemuneracaoDesconto.where(partner_id: parceiro.id, remuneracao_id: remuneracao.id)
          if remuneracao_descontos.count > 0
            remuneracao_desconto = remuneracao_descontos.first
            if remuneracao_desconto.desconto_parceiro.present?
              desconto = remuneracao_desconto.desconto_parceiro.porcentagem
            else
              desconto = parceiro.desconto
            end
          else
            desconto = parceiro.desconto
          end
        end
      else
        desconto = parceiro.desconto
      end
    end

    desconto_aplicado = valor.to_f * desconto.to_f / 100
    valor_original = valor
    valor = valor - desconto_aplicado

    return [desconto_aplicado, valor_original, valor, desconto]
  end

  def self.venda_zapfibra(params, usuario, ip)
    self.venda_zaptv(params, usuario, ip)
  end

  def self.venda_zaptv(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip)

    raise PagasoError.new("Digite o telemovel") if params[:zaptv_cartao].blank?

    telefone = params[:zaptv_cartao]
    request_id = Time.zone.now.strftime("%d%m%Y%H%M%S")

    if Rails.env == "development"
      host = "#{parametro.get.url_integracao_desenvolvimento}"
      api_key = parametro.get.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.get.url_integracao_producao}"
      api_key = parametro.get.api_key_zaptv_producao
    end

    body_send = {
      :price => valor_original, 
      :product_code => produto.produto_id_parceiro, #produto importado zap
      :product_quantity => 1, 
      :source_reference => request_id, #meu código 
    }

    if parametro.get.categoria.to_s.downcase == "wifi"
      body_send[:telefone] = telefone
    else
      body_send[:zappi] = telefone #Iremos receber este numero
    end
    
    body_send = body_send.to_json

    res = HTTParty.post(
      host, 
      headers: {
        "apikey" => api_key,
        "Content-Type" => "application/json"
      },
      :body => body_send, timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, agent_id: parametro.get.zaptv_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, request_id: request_id, customer_number: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!
    
    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = "#{host} ------ api_key=#{api_key} -------- body=#{body_send}"
    venda.response_get = res.body

    begin
      venda.status = JSON.parse(res.body)["status_code"]
    rescue;end

    venda.status ||= res.code
    venda.save!

    if venda.sucesso?
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
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: (banco.id rescue Banco.first.id),
        partner_id: parceiro.id,
        iban: iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!
    end

    return venda
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def self.confirma_venda!(venda, uniq_number, meter_number, produto, valor, desconto_aplicado, valor_original, porcentagem_desconto, usuario, parceiro)
    info, xml_enviado, xml_recebido = Ende.informacoes_meter_number(meter_number, uniq_number)
    info = info.first

    venda.request_send = xml_enviado
    venda.response_get = xml_recebido
    venda.save!

    if info.blank?
      venda.status = "ende-0"
      venda.error_message = ErroAmigavel.traducao("Venda não autorizada")
      return PagasoEndeError.new(venda.error_message) 
    elsif info["erro"].present?
      venda.status = "ende-1"
      venda.error_message = ErroAmigavel.traducao(info["erro"])
    elsif info["minVendAmt"].present? && info["minVendAmt"]["value"].to_i > 0
      venda.status = "ende-2"
      venda.error_message = "Valor Máximo de Compra: #{Ende.akz_parse(info["minVendAmt"]["symbol"])} #{info["minVendAmt"]["value"]} - Data envio: #{info["respDateTime"].strftime("%d/%m/%Y %H:%M:%S")}"
    end

    venda.save!
    raise PagasoEndeError.new(venda.error_message) if venda.status.present?
  rescue PagasoEndeError => e
    raise PagasoEndeError.new(e.message)
  rescue Exception => e
    if e.message.downcase.include?("timeout")
      begin
        info, xml_enviado, xml_recebido = Ende.last_advice(uniq_number.data, uniq_number.unique_number)
        info = info.first
        venda.error_message = info["erro"]
        venda.status = "ende-4"
        venda.request_send = xml_enviado
        venda.response_get = xml_recebido
        venda.save!
        raise PagasoEndeError.new(venda.error_message)
      rescue Exception => er
        Rails.logger.info "========================="
        Rails.logger.info er.message
        Rails.logger.info "========================="
        Rails.logger.info er.backtrace
        Rails.logger.info "========================="

        venda.error_message = er.message
        venda.status = "ende-4"
        venda.log_erro_text = er.backtrace
        venda.save!

        raise PagasoError.new(er.message)
      end
    end

    raise PagasoError.new(e.message)
  end
  
  def token_e_data_ende
    return nil if self.request_id.blank?
    uniq_number = EndeUniqNumber.find(self.request_id)
    info = Ende.informacoes_parse(self.response_get, uniq_number).first
    return [info["stsCipher"], info["respDateTime"]]
  rescue
    return nil
  end

  def self.venda_ende(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip)

    meter_number = params[:meter_number]
    raise PagasoError.new("Digite o Número do Medidor") if meter_number.blank?
    raise PagasoError.new("Número do Medidor Inválido") if !Ende.validate_meter_number(meter_number)
    if params[:api].blank?
      raise PagasoError.new("Digite o Número SMS para envio do token de recarga") if params[:talao_sms_ende].blank?
    end

    host = Rails.env == "development" ? "#{parametro.get.url_integracao_desenvolvimento}" : "#{parametro.get.url_integracao_producao}"

    uniq_number = EndeUniqNumber.create(data: Time.zone.now)
    venda = Venda.new(canal_venda: params[:api], product_id: produto.id, product_nome: produto.description, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, request_id: uniq_number.id, customer_number: meter_number, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro
    venda.save!

    uniq_number_confirma = EndeUniqNumber.create(data: Time.zone.now, venda_id: venda.id)
    begin
      confirma_venda!(venda, uniq_number_confirma, meter_number, produto, valor, desconto_aplicado, valor_original, porcentagem_desconto, usuario, parceiro)
    rescue PagasoEndeError => e
      venda.log_erro_text = e.backtrace
      venda.error_message = e.message
      venda.request_id = uniq_number_confirma.id
      venda.save!
      return venda
    end

    request_send = ""
    response_get = ""
    last_request = ""

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sch=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xmlns:sch1=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xmlns:sch2=\"http://www.nrs.eskom.co.za/xmlvend/meter/2.1/schema\">
      <soapenv:Header/>
      <soapenv:Body>
      <sch:creditVendReq xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">
        <clientID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.get.client_id}\"/>
        <terminalID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" xsi:type=\"EANDeviceID\" ean=\"#{parametro.get.terminal_id}\"/>
        <msgID xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\" dateTime=\"#{Time.zone.now.strftime("%Y%m%d%H%M%S")}\" uniqueNumber=\"#{uniq_number.unique_number}\"/>
        <authCred xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <opName>#{parametro.get.operator_id}</opName>
        <password>#{parametro.get.password}</password>
        </authCred>
                            
        <idMethod xmlns=\"http://www.nrs.eskom.co.za/xmlvend/base/2.1/schema\">
        <meterIdentifier xsi:type=\"MeterNumber\" msno=\"#{meter_number}\"/>
        </idMethod>
        <purchaseValue xmlns=\"http://www.nrs.eskom.co.za/xmlvend/revenue/2.1/schema\" xsi:type=\"PurchaseValueCurrency\">
        <amt value=\"#{valor_original}\" symbol=\"AOA\"/>
        </purchaseValue>
      </sch:creditVendReq>
      </soapenv:Body>
      </soapenv:Envelope>
    "
    
    uniq_number.xml_enviado = body
    uniq_number.venda_id = venda.id
    uniq_number.save!

    request_send += "=========[creditVendReq]========"
    request_send += body
    request_send += "=========[creditVendReq]========"

    url = "#{host}"

    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "",
      },
      :body => body,
      :timeout => 120.seconds
    )
    
    response_get += "=========[creditVendReq]========"
    response_get += request.body
    response_get += "=========[creditVendReq]========"

    last_request = request.body

    uniq_number.xml_recebido = last_request
    uniq_number.save!

    venda.request_id = uniq_number.id
    venda.request_send = request_send
    venda.response_get = response_get

    venda.error_message = ErroAmigavel.traducao(Nokogiri::XML(last_request.scan(/<fault .*?<\/fault>/).first).text) rescue ""
    if venda.error_message.present?
      venda.status = "ende-5"
    else
      status = last_request.downcase.scan(/stscipher.*?stscipher/).length > 0
      if status 
        venda.status = "1" # sucesso
      else
        venda.error_message = ErroAmigavel.traducao("Token não localizado")
        venda.status = "ende-99"
      end
    end
    
    venda.save!

    if venda.sucesso?
      lancamento = Lancamento.where(nome: Lancamento::COMPRA_DE_CREDITO_OU_RECARGA).first
      lancamento = Lancamento.first if lancamento.blank?

      conta_corrente = ContaCorrente.new(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
        partner_id: parceiro.id,
        iban: ContaCorrente.where(usuario_id: usuario.id).first.iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!

      info = Ende.informacoes_parse(last_request, uniq_number).first
      stscipher = info["stsCipher"]
      receiptNo = info["receiptNo"]
      respdatetime = info["respDateTime"]
      respdatetime = respdatetime.to_datetime.strftime("%d/%m/%Y %H:%M:%S") rescue respdatetime

      energia = []
      info["creditTokenIssue"].each do |creditTokenIssue|
        #energia << "#{creditTokenIssue["units"]["value"]} #{creditTokenIssue["units"]["siUnit"]}" rescue ""
        energia << "#{creditTokenIssue["units"]["siUnit"]}: #{creditTokenIssue["units"]["value"]} " rescue ""
      end

      assunto_email = "ENDE PRE-PAGO"
      mensagem = "#{assunto_email} #{respdatetime} Contador: #{meter_number} Kz: #{Venda.helper.number_to_currency(valor_original, :unit => "")} #{energia.join(" ")} Codigo Recarga: #{stscipher} Contact Center: 923166850"
      
      if params[:api].blank?
        envia, resposta = Sms.enviar(params[:talao_sms_ende], mensagem)

        sms_log = SmsHistoricoEnvio.new(numero: params[:talao_sms_ende], conteudo: mensagem, usuario_id: usuario.id, venda_id: venda.id, sucesso: true)
        if envia
          sms_log.save!
        else
          sms_log.sucesso = false
          sms_log.save!
          LogVenda.create(usuario_id: usuario.id, titulo: "SMS não enviado para venda id (#{venda.id}) dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: resposta.inspect)
        end
      end

      if params[:email].present?
        email_log = EmailHistoricoEnvio.new(email: params[:email], titulo: assunto_email, usuario_id: usuario.id, venda_id: venda.id, sucesso: true)
        info["venda"] = venda
        begin
          UsuarioMailer.notificacao_de_venda(assunto_email, params[:email], info).deliver
          email_log.save!
        rescue Exception => erro
          email_log.conteudo = "#{erro.message} - #{erro.backtrace}"
          email_log.sucesso = false
          email_log.save!
          LogVenda.create(usuario_id: usuario.id, titulo: "Email não enviado para venda id (#{venda.id}) dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: erro.backtrace)
        end
      end
    end

    return venda
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def status_movicel
    return if self.partner.name.downcase != "movicel"

    require 'openssl'

    parceiro = Partner.movicel
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
      agent_key = parametro.get.agent_key_movicel_desenvolvimento
      user_id = parametro.get.user_id_movicel_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
      agent_key = parametro.get.agent_key_movicel_producao
      user_id = parametro.get.user_id_movicel_producao
    end

    request_id = self.request_id

    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaendazapes/movicell/ubuntu/encripto`
    pass = pass.strip

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
         <soapenv:Header>
            <int:QueryTransactionReqHeader>
               <mid:RequestId>#{request_id}</mid:RequestId>
               <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
               <mid:SourceSystem>#{user_id}</mid:SourceSystem>
               <mid:Credentials>
                  <mid:User>#{user_id}</mid:User>
                  <mid:Password>#{pass}</mid:Password>
               </mid:Credentials>
               <mid:Attributes>
                  <mid:Attribute>
                     <mid:Name>?</mid:Name>
                     <mid:Value>?</mid:Value>
                  </mid:Attribute>
               </mid:Attributes>
            </int:QueryTransactionReqHeader>
         </soapenv:Header>
         <soapenv:Body>
            <int:QueryTransactionReq>
               <int:QueryTransactionReqBody>
                  <mid1:TransactionNumber>?</mid1:TransactionNumber>
               </int:QueryTransactionReqBody>
            </int:QueryTransactionReq>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    url = "#{url_service}/DirectTopupService/Topup/"
    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryTransaction",
      },
      :body => body, timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    if (200...300).include?(request.code.to_i)
      # return request.body
      return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
      # return "#{request_id} - #{Nokogiri::XML(request.body).children.children.children.children.children.text}" rescue nil
    end
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.backtrace}"
  end

  def self.venda_movicel(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip, params[:valor].to_i)
    
    raise PagasoError.new("Digite o telemóvel") if params[:movicel_telefone].blank?
    
    telefone = params[:movicel_telefone]

    require 'openssl'

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
      agent_key = parametro.get.agent_key_movicel_desenvolvimento
      user_id = parametro.get.user_id_movicel_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
      agent_key = parametro.get.agent_key_movicel_producao
      user_id = parametro.get.user_id_movicel_producao
    end

    #producao

    #homologacao
    # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    # url_service = "http://wsqa.movicel.co.ao:10071"

    msisdn = telefone
    request_id = Time.zone.now.strftime("%d%m%Y%H%M%S")

    cripto = "AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto"
    Rails.logger.info "=========[cripto]========"
    pass = `#{cripto}`
    Rails.logger.info "=========[cripto]========"

    pass = pass.strip

    request_send = ""
    response_get = ""
    last_request = ""

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
        <soapenv:Header>
         <int:ValidateTopupReqHeader>
            <mid:RequestId>#{request_id}</mid:RequestId>
            <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
            <mid:SourceSystem>#{user_id}</mid:SourceSystem>  
            <mid:Credentials>
               <mid:User>#{user_id}</mid:User>
               <mid:Password>#{pass}</mid:Password>
               </mid:Credentials>
            </int:ValidateTopupReqHeader>
        </soapenv:Header>
        <soapenv:Body>
            <int:ValidateTopupReq>
               <int:ValidateTopupReqBody>
                  <mid1:Amount>#{valor_original}</mid1:Amount>
                  <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
               </int:ValidateTopupReqBody>
            </int:ValidateTopupReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    data_envio = Time.zone.now

    request_send += "=========[ValidateTopup - #{data_envio.to_s}]========"
    request_send += cripto
    request_send += "=========[Cripto]========"
    request_send += body
    request_send += "=========[ValidateTopup]========"

    Rails.logger.info request_send
    Rails.logger.info "========[Enviando para operadora Movicel - #{data_envio.to_s}]=========="

    url = "#{url_service}/DirectTopupService/Topup/"
    uri = URI.parse(URI::Parser.new.escape(url))
    begin
      request = HTTParty.post(uri, 
        headers: {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup",
        },
        timeout: DEFAULT_TIMEOUT.to_i.seconds,
        body: body
      )

      Rails.logger.info "========[Dados enviados para operadora Movicel]=========="

      response_get += "=========[ValidateTopup - #{Time.zone.now.to_s} - Tempo de envio: #{Time.zone.now - data_envio} ]========"
      response_get += request.body
      response_get += "=========[ValidateTopup]========"
      Rails.logger.info response_get

      if (200...300).include?(request.code.to_i) && request.body.include?("200</ReturnCode>")

        body = "
          <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
            <soapenv:Header>
                <int:TopupReqHeader>
                  <mid:RequestId>#{request_id}</mid:RequestId>
                  <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
                  <mid:SourceSystem>#{user_id}</mid:SourceSystem>
                  <mid:Credentials>
                      <mid:User>#{user_id}</mid:User>
                      <mid:Password>#{pass}</mid:Password>
                  </mid:Credentials>
                </int:TopupReqHeader>
            </soapenv:Header>
            <soapenv:Body>
                <int:TopupReq>
                  <int:TopupReqBody>
                      <mid1:Amount>#{valor_original}</mid1:Amount>
                      <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
                      <mid1:Type>Default</mid1:Type>
                  </int:TopupReqBody>
                </int:TopupReq>
            </soapenv:Body>
          </soapenv:Envelope>
        "

        data_envio = Time.zone.now
        request_send += "=========[Topup - #{data_envio.to_s}]========"
        request_send += body
        request_send += "=========[Topup]========"
        Rails.logger.info request_send

        Rails.logger.info "========[Enviando confirmação para operadora Movicel]=========="

        url = "#{url_service}/DirectTopupService/Topup/"
        uri = URI.parse(URI::Parser.new.escape(url))
        begin
          request = HTTParty.post(uri, 
            headers: {
              'Content-Type' => 'text/xml;charset=UTF-8',
              'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup",
            },
            timeout: DEFAULT_TIMEOUT.to_i.seconds,
            body: body
          )
          
          response_get += "=========[Topup - #{Time.zone.now.to_s} - Tempo de envio: #{Time.zone.now - data_envio}]========"
          response_get += request.body
          response_get += "=========[Topup]========"
          Rails.logger.info response_get

          Rails.logger.info "========[Confirmação enviada para operadora Movicel]=========="

          last_request = request.body

          venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, agent_id: parametro.get.movicel_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, request_id: request_id, customer_number: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
          venda.responsavel = usuario
          venda.save!

          venda.store_id = usuario.sub_agente.store_id_parceiro
          venda.seller_id = usuario.sub_agente.seller_id_parceiro
          venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

          venda.request_send = request_send
          venda.response_get = response_get
          venda.status = last_request.scan(/ReturnCode.*?<\/ReturnCode/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue "3"
          venda.save!

          if venda.sucesso?
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
              observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
              lancamento_id: lancamento.id,
              banco_id: banco.id,
              partner_id: parceiro.id,
              iban: iban,
              venda_id: venda.id
            )

            conta_corrente.responsavel = usuario
            conta_corrente.save!
          end

          return venda
        rescue Exception => err
          url = "#{url_service}/DirectTopupService/Topup/"
          payload = {
            headers: {
              'Content-Type' => 'text/xml;charset=UTF-8',
              'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup",
            },
            timeout: DEFAULT_TIMEOUT.to_i.seconds,
            body: body
          }
          raise PagasoError.new("#{err.message} - Erro ao enviar dados para api - URL = #{url} - payload = #{payload} - backtrace = #{err.backtrace}")
        end
      else
        return_message = request.body.scan(/<ReturnMessage.*?ReturnMessage>/)
        if return_message.present?
          return_message = return_message.first.gsub(/<[^>]*>/, "") rescue return_message
          raise PagasoError.new("Erro no envio do pedido ou resposta da  - (#{return_message})")
        end
        raise PagasoError.new("Erro no envio do pedido ou resposta da operadora - Timeout")
      end
    rescue Exception => err
      url = "#{url_service}/DirectTopupService/Topup/"
      payload = {
        headers: {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup",
        },
        timeout: DEFAULT_TIMEOUT.to_i.seconds,
        body: body
      }
      raise PagasoError.new("#{err.message} - Erro ao enviar dados para api - URL = #{url} - payload = #{payload} - backtrace = #{err.backtrace}")
    end
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def status_dstv
    return if self.partner.name.downcase != "dstv"
    return 0
  end

  def self.venda_dstv(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip, params[:valor].to_i)

    smartcard = params[:transacao_smartcard].blank? ? true : ActiveModel::Type::Boolean.new.cast(params[:transacao_smartcard])
    raise PagasoError.new("Digite o número do cliente/customer number") if params[:dstv_number].blank?

    require 'openssl'

    # transaction_number = (Venda.order("id desc").first.id + 1)
    transaction_number = Time.now.to_i

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
      data_source = parametro.get.data_source_dstv_desenvolvimento
      payment_vendor_code = parametro.get.payment_vendor_code_dstv_desenvolvimento
      vendor_code = parametro.get.vendor_code_dstv_desenvolvimento
      agent_account = parametro.get.agent_account_dstv_desenvolvimento
      currency = parametro.get.currency_dstv_desenvolvimento
      product_user_key = parametro.get.product_user_key_dstv_desenvolvimento
      mop = parametro.get.mop_dstv_desenvolvimento # mop = "CASH, MOBILE or ATM " # “Mobile, Web ou USSD”
      agent_number = parametro.get.agent_number_dstv_desenvolvimento #122434345
    else
      url_service = parametro.get.url_integracao_producao
      data_source = parametro.get.data_source_dstv_producao
      payment_vendor_code = parametro.get.payment_vendor_code_dstv_producao
      vendor_code = parametro.get.vendor_code_dstv_producao
      agent_account = parametro.get.agent_account_dstv_producao
      currency = parametro.get.currency_dstv_producao
      product_user_key = parametro.get.product_user_key_dstv_producao
      mop = parametro.get.mop_dstv_producao # mop = "CASH, MOBILE or ATM " # “Mobile, Web ou USSD”
      agent_number = parametro.get.agent_number_dstv_producao #122434345
    end

    request_send = ""
    response_get = ""
    last_request = ""

    customer_number = params[:dstv_number]
    
    if smartcard
      informacoes_device_number = Dstv.informacoes_device_number(params[:dstv_number], ip)
      customer_number = informacoes_device_number[:customer_detail]["number"]
    end
    
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{transaction_number}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{customer_number}</sel1:customerNumber>
            <sel1:amount>#{valor_original}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>AOA</sel1:currency>
            <sel1:paymentDescription>Pagaso Payment System</sel1:paymentDescription>
            <sel1:methodofPayment>#{mop}</sel1:methodofPayment>
            <sel1:agentNumber>#{agent_number}</sel1:agentNumber>
            <sel1:productCollection>
              <sel1:Product>
                <sel1:productUserkey>#{produto.produto_id_parceiro}</sel1:productUserkey>
              </sel1:Product>
            </sel1:productCollection>
            <sel1:baskedId>0</sel1:baskedId>
          </sel:agentPaymentRequest>
          <sel:VendorCode>#{vendor_code}</sel:VendorCode>
          <sel:language>Portuguese</sel:language>
          <sel:ipAddress>#{ip}</sel:ipAddress>
          <sel:businessUnit>DStv</sel:businessUnit>
        </sel:AgentSubmitPayment>
        </soapenv:Body>
      </soapenv:Envelope>
    "
    @source = "AgentSubmitPayment"

    request_send += "=========[SubmitPaymentBySmartCard_AgentSubmitPayment]========"
    request_send += body
    request_send += "=========[SubmitPaymentBySmartCard]_AgentSubmitPayment========"

    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/#{@source}",
      },
      :body => body
    )
    
    response_get += "=========[SubmitPaymentBySmartCard_AgentSubmitPayment]========"
    response_get += request.body
    response_get += "=========[SubmitPaymentBySmartCard_AgentSubmitPayment]========"

    last_request = request.body

    SequencialDstv.create!(numero: transaction_number, request_body: request.body, response_body: body)
    
    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, agent_id: parametro.get.dstv_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, request_id: transaction_number, customer_number: params[:dstv_number], usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = request_send
    venda.response_get = response_get
    erro_message = last_request.to_s.gsub("\n", "").downcase.scan(/faultstring.*?<\/faultstring/).first.scan(/>.*?</).first.gsub(/<|>/, "") rescue ""

    if erro_message.present? 
      erro_message = erro_message.downcase
      if erro_message.include?("duplicate transaction")
        venda.status = "31"
      elsif erro_message.include?("incorrect customernumber")
        venda.status = "32"
      elsif erro_message.include?("must be greater than zero")
        venda.status = "33"
      elsif erro_message.include?("insufficient agent funds. payment amount is greater")
        venda.status = "34"
      elsif erro_message.include?("customers who have not been active on any principal package")
        venda.status = "35"
      end
    else
      status = last_request.downcase.scan(/status.*?<\/a\:status/).first.gsub(/status|\>|\<|a|\:|\//, "") rescue ""
      status = last_request.downcase.scan(/status.*?<\/b\:status/).first.gsub(/status|\>|\<|b|\:|\//, "") rescue "false" if status.blank?
      venda.status = (status == "true" ? "1" : "3")
    end

    venda.save!

    if venda.sucesso?
      lancamento = Lancamento.where(nome: Lancamento::COMPRA_DE_CREDITO_OU_RECARGA).first
      lancamento = Lancamento.first if lancamento.blank?

      conta_corrente = ContaCorrente.new(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
        partner_id: parceiro.id,
        iban: ContaCorrente.where(usuario_id: usuario.id).first.iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!
    end

    return venda
  end

  def message_api_terceiro
    self.response_get.to_s.gsub("\n", "").downcase.scan(/faultstring.*?<\/faultstring/).first.scan(/>.*?</).first.gsub(/<|>/, "") rescue ""
  end

  def message_api_terceiro_para_busca
    Venda.mensagem_busca_erro(self.message_api_terceiro, self.partner)
  end

  def self.mensagem_busca_erro(mensagem, parceiro)
    if parceiro.present?
      if parceiro.slug.to_s.downcase == "dstv"
        return mensagem[0, 100]
      end
    end
    
    mensage = mensagem.strip.gsub(/:.*/, "") rescue mensagem
    mensage = mensage.split("-").first.to_s.strip rescue mensagem

    return mensage
  end

  def self.venda_unitel(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip, params[:valor].to_i)
    valor_original = valor_original.to_i

    raise PagasoError.new("Digite o telemóvel") if params[:unitel_telefone].blank?

    telefone = params[:unitel_telefone]

    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, agent_id: parametro.get.unitel_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, customer_number: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    sequence = UnitelSequence.order("id desc").first
    sequence_id = sequence.blank? ? 1 : (sequence.sequence_id + 1)
    unitel_sequence = UnitelSequence.create(sequence_id: sequence_id)

    if Rails.env == "development"
      make_sale_endpoint = "#{parametro.get.url_integracao_desenvolvimento}/spgw/V2/makeSale"
      dados_envio = "./chaves/unitel_recarga.sh '#{sequence_id}' '#{venda.produto_id_parceiro}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor_original}' '#{venda.customer_number}' '#{make_sale_endpoint}'"
    else
      make_sale_endpoint = "#{parametro.get.url_integracao_producao}/spgw/V2/makeSale"
      dados_envio = "./chaves/unitel_recarga_producao.sh '#{sequence_id}' '#{venda.produto_id_parceiro}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor_original}' '#{venda.customer_number}' '#{make_sale_endpoint}'"
    end


    Rails.logger.info "==================[#{dados_envio}]============="

    retorno = ""
    begin
      retorno = `#{dados_envio}`
    rescue Exception => erro
      unitel_sequence.log = "#{erro.message} - #{erro.backtrace}"
      unitel_sequence.save
      raise erro.message
    end

    venda.request_send, venda.response_get = retorno.split(" --- ")

    venda.request_send = "#{venda.request_send} ========== #{dados_envio}"

    venda.status = venda.response_get_parse["statusCode"] rescue "3"
    venda.save!

    unitel_sequence.venda_id = venda.id
    unitel_sequence.save

    if venda.sucesso?
      lancamento = Lancamento.where(nome: Lancamento::COMPRA_DE_CREDITO_OU_RECARGA).first
      lancamento = Lancamento.first if lancamento.blank?

      conta_corrente = ContaCorrente.new(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        partner_id: parceiro.id,
        banco_id: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
        iban: ContaCorrente.where(usuario_id: usuario.id).first.iban,
        venda_id: venda.id
      )

      conta_corrente.responsavel = usuario
      conta_corrente.save!
    end

    return venda
  end
  
  def lucro
    self.value
  end

  def self.venda_africell(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip)

    raise PagasoError.new("Digite o Telemóvel / MSISDN") if params[:target_msisdn].blank?
   
    jwt_token, parceiro, parametro, url_service = Africell.refresh_token
    raise PagasoError.new("Token expirado") if jwt_token.blank?

    url = "#{url_service}#{parametro.get.endpoint_HTTP_Recharge}"
    uri = URI.parse(URI::Parser.new.escape(url))

    transaction_reference = SecureRandom.uuid
    if produto.parameter_code_africell == "00" && produto.produto_id_parceiro == "00"
      Rails.logger.info "===========Amount[#{valor_original}] - [00-00]============="
      amount = valor_original
    else
      Rails.logger.info "===========Amount: []============="
      amount = ""
    end

    if params[:target_msisdn][0, 3] != "244"
      numero_africell = "244".to_s + params[:target_msisdn].to_s
    else
      numero_africell = params[:target_msisdn]
    end

    body = {
      'ProductCode': produto.produto_id_parceiro,
      'ParameterCode': produto.parameter_code_africell,
      'Amount': amount,
      'TargetMSISDN': numero_africell,
      'TransactionReference': transaction_reference
    }.to_json

    res = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => jwt_token,
      },
      body: body,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, request_id: transaction_reference, customer_number: numero_africell, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!
    
    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = "#{url} ---------- body=#{body}"
    venda.response_get = res.body

    begin
      venda.status = JSON.parse(res.body)["StatusCode"]
    rescue;end

    venda.status ||= res.code
    venda.save!

    if venda.sucesso?
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
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: (banco.id rescue Banco.first.id),
        partner_id: parceiro.id,
        iban: iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!
    end

  return venda
  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def redirect
    return self.partner_id == Partner.ende.id || self.partner_id == Partner.elephantbet.id
  end

  def self.venda_elephantbet(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip)

    raise PagasoError.new("Digite o número do telefone do jogador") if params[:elephantbet_telefone].blank?
    params[:elephantbet_telefone] = "+244#{params[:elephantbet_telefone]}" unless params[:elephantbet_telefone].to_s.include?("+244")

    elephant_bet_login, parceiro, parametro, url_service = ElephantBet.login
    sessao = JSON.parse(elephant_bet_login.body_request)
    session_id = sessao["loginInformation"]["session"] rescue nil

    raise PagasoError.new("Sessão expirada") if session_id.blank?

    url = "#{url_service}#{parametro.get.endpoint_HTTP_Heartbeat}?session=#{session_id}"
    uri = URI.parse(URI::Parser.new.escape(url))

    body = {
      "session": "#{session_id}",
    }.to_json

    res = HTTParty.patch(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{parametro.get.bearer_token_default}",
      },
      body: body,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    sucesso = JSON.parse(res.body)["success"] rescue false

    raise PagasoError.new("Fazer login novamente depois") if !sucesso

    url = "#{url_service}#{parametro.get.endpoint_HTTP_VouchersCreateOnlyPlayable}?session=#{session_id}"
    uri = URI.parse(URI::Parser.new.escape(url))

    body = {
      "playerReference": params[:elephantbet_telefone],
      "amount": valor_original,
      "payment": {
          "mode": "external"
      },
      "distribution": "digital"
    }.to_json

    res = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{parametro.get.bearer_token_default}",
      },
      body: body,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    transaction_reference = JSON.parse(res.body)["voucher"]["reference"] rescue ""
    payment_code = JSON.parse(res.body)["voucher"]["paymentCode"] rescue ""
    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, transaction_reference: transaction_reference, customer_number: params[:elephantbet_telefone], payment_code: payment_code, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!
    
    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = "#{url} ---------- body=#{body}"
    venda.response_get = res.body

    venda.status = JSON.parse(res.body)["success"].to_s rescue nil
    venda.status ||= res.code
    venda.save!

    if venda.sucesso?
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
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: (banco.id rescue Banco.first.id),
        partner_id: parceiro.id,
        iban: iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!

      if params[:api].blank? && params[:voucher_sms_elephantbet].present?
        
        assunto_email = "ElephantBet Voucher"
        creation_date_time = JSON.parse(res.body)["voucher"]["creationDatetime"].to_datetime.strftime("%d/%m/%Y %H:%M:%S")  rescue ""
        transaction_reference = JSON.parse(res.body)["voucher"]["reference"] rescue ""
        endValidity = JSON.parse(res.body)["voucher"]["endValidity"].to_datetime.strftime("%d/%m/%Y %H:%M:%S")  rescue ""
        payment_code = JSON.parse(res.body)["voucher"]["paymentCode"] rescue ""
        playerReference = JSON.parse(res.body)["voucher"]["playerReference"] rescue ""

        mensagem = "#{assunto_email} #{creation_date_time} Referência:#{transaction_reference} Valor:#{Venda.helper.number_to_currency(valor_original, :precision => 2)} Validade:#{endValidity} Voucher:#{payment_code}"

        envia, resposta = Sms.enviar(params[:voucher_sms_elephantbet], mensagem)

        sms_log = SmsHistoricoEnvio.new(numero: params[:voucher_sms_elephantbet], conteudo: mensagem, usuario_id: usuario.id, venda_id: venda.id, sucesso: true)
        if envia
          sms_log.save!
        else
          sms_log.sucesso = false
          sms_log.save!
          LogVenda.create(usuario_id: usuario.id, titulo: "SMS não enviado para venda id (#{venda.id}) dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M")}", log: resposta.inspect)
        end
      end
    end

    venda
  end

  def self.venda_bantubet(params, usuario, ip)
    desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro = valida_informacoes_para_venda(params, usuario, ip)

    raise PagasoError.new("Digite o número do telefone do jogador") if params[:bantubet_telefone].blank?
    #params[:bantubet_telefone] = "+244#{params[:bantubet_telefone]}" unless params[:bantubet_telefone].to_s.include?("+244")

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
    end

    bt_resource = "#{parametro.get.resource}"
    secret_key = "#{parametro.get.secret_key}"
    command = "pay"
    account = params[:bantubet_telefone]
    payment_id = "#{parametro.get.payment_id}"
    amount = valor_original
    currency = "AOA"
    txn_id = Time.now.to_i 
    sid = "#{parametro.get.sid}"

    require 'digest'
    hashcode = Digest::MD5.new.hexdigest("#{command}#{txn_id}#{account}#{amount}#{currency}#{sid}#{parametro.get.secret_key}")

    url = "#{url_service}/#{parametro.get.endpoint_Transactions}/#{bt_resource}/?command=#{command}&account=#{account}&paymentID=#{payment_id}&amount=#{amount}&currency=#{currency}&txn_id=#{txn_id}&hashcode=#{hashcode}&sid=#{sid}"

    res = HTTParty.get(url, 
      :headers => {
        'Content-Type' => 'application/json',
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )

    sucesso = JSON.parse(res.body)["response"]["code"].to_s rescue ""
    sucesso = (sucesso == "0").to_s

    venda = Venda.new(canal_venda: params[:api], produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.id, product_nome: produto.description, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, porcentagem_desconto: porcentagem_desconto, transaction_reference: txn_id, customer_number: params[:bantubet_telefone], payment_code: txn_id, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!
    
    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = "#{url}"
    venda.response_get = res.body

    venda.status = sucesso
    venda.save!

    if venda.sucesso?
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
        observacao: "Compra de recarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: (banco.id rescue Banco.first.id),
        partner_id: parceiro.id,
        iban: iban,
        venda_id: venda.id
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!

    end
  return venda

  rescue PagasoError => e
    raise "#{e.message} - #{e.backtrace}"
  rescue Net::ReadTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Net::OpenTimeout => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Errno::ETIMEDOUT => e
    raise "Timeout. Sem resposta da operadora - #{e.backtrace}"
  rescue Exception => e
    raise "Erro ao tentar executar a transação. Entre em contato com o Administrador - #{e.class} - #{e.backtrace}"
  end

  def self.valida_informacoes_para_venda(params, usuario, ip, valor = nil)
    valor = params[:valor].to_f if valor.blank?

    raise PagasoError.new("Valor é obrigatório") if valor < 0.1
  
    raise PagasoError.new("Produto não selecionado") if params[:produto_id].blank?
  
    produto = Produto.where(id: params[:produto_id]).first
    raise PagasoError.new("Produto não encontrado") if produto.blank?
    if produto.valor_compra_telemovel > 0
      if produto.valor_compra_telemovel.to_f != valor
        raise PagasoError.new("O valor do produto informado não corresponde ao valor do produto no portfolio")
      end
    end
  
    parceiro = produto.partner
    raise PagasoError.new("Parceiro não localizado") if parceiro.blank?
  
    desconto_aplicado, valor_original, valor, porcentagem_desconto = desconto_venda(usuario, parceiro, valor)
  
    parametro = Parametro.where(partner_id: parceiro.id)
    parametro = parametro.where("upper(categoria) = ?", produto.categoria.upcase) if produto.categoria.present?
    parametro = parametro.first
    raise PagasoError.new("Parâmetros não localizados") if parametro.blank?
  
    raise PagasoError.new("O saldo do agente Pagasó é insuficiente para realizar a recarga") if usuario.saldo < valor
   
    raise PagasoError.new("Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador") if usuario.sub_agente.blank?
  
    [desconto_aplicado, valor_original, valor, porcentagem_desconto, parametro, produto, parceiro]
  end

  before_save do 
    self.categoria = self.product.categoria
  end

  after_create do 
    Log.save_log("Inclusão de registro (#{self.class.to_s})", self.attributes)
  end

  before_update do 
    Log.save_log("Alteração de registro (#{self.class.to_s})", self.attributes)
  end

  before_destroy do 
    Log.save_log("Exclusão de registro (#{self.class.to_s})", self.attributes)
  end

  def self.moeda_csv(valor)
    valor.gsub(".", "").gsub(",", ".")
  end

  def self.helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  def atualizar_vendas_consolidadas
    if self.sucesso?
      venda_consolidada = VendasConsolidada.where(venda_id: self.id).first
      venda_consolidada = VendasConsolidada.new if venda_consolidada.blank?
      venda_consolidada.venda_id = self.id
      venda_consolidada.usuario_id = self.usuario_id
      venda_consolidada.usuario_nome = self.usuario.nome
      venda_consolidada.usuario_login = self.usuario.login
      venda_consolidada.status_cliente_id = self.usuario.status_cliente_id
      venda_consolidada.status_cliente_nome = self.usuario.status_cliente.nome
      venda_consolidada.partner_status_parceiro_id = self.partner.status_parceiro_id
      venda_consolidada.partner_status_parceiro_nome = self.partner.status_parceiro.nome
      venda_consolidada.vendas_valor_original_valor = self.valor_original
      venda_consolidada.vendas_desconto_aplicado_lucro = self.desconto_aplicado
      venda_consolidada.porcentagem_vendas_desconto_aplicado = self.porcentagem_desconto
      venda_consolidada.vendas_value_custo = self.value
      venda_consolidada.vendas_created_at = self.created_at
      venda_consolidada.vendas_updated_at = self.updated_at
      venda_consolidada.vendas_product_id = self.product_id
      venda_consolidada.vendas_product_nome = self.product.description
      venda_consolidada.vendas_product_subtipo = self.product.subtipo
      venda_consolidada.vendas_product_categoria = self.product.categoria
      venda_consolidada.return_code_api_return_code = self.status_desc.return_code
      venda_consolidada.return_code_api_error_description_pt = self.status_desc.error_description_pt 
      venda_consolidada.return_code_api_partner_name = self.status_desc.partner.name rescue venda_consolidada.partner_status_parceiro_nome
      venda_consolidada.save
    end
  end
end
