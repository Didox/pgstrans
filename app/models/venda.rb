class Venda < ApplicationRecord
  include PermissionamentoDados
  #default_scope { order(updated_at: :desc) }
  default_scope { order(id: :desc) }
  belongs_to :usuario
  belongs_to :partner

  after_save :update_product

  def grupos_id
    #TODO - Verificar como pegar os grupos de acesso de um registro
    [].map{|g| g.id}.join(",")
  end

  def self.to_csv
    attributes = "Usuário,Parceiro,Data da Venda,Status da Venda,Produto ID Parceiro, Produto ID Pagaso,Nome do Produto,Agente,Store,ID do Vendedor,Terminal,Customer Number/MSIDN,Valor Face,Desconto,Porcentagem Desconto,Lucro".split(",")

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |venda|
        porcentagem = (venda.desconto_aplicado.to_f / venda.valor_original.to_f * 100) 
        porcentagem = porcentagem.nan? ? 0 : porcentagem.round(2)

        csv << [
          venda.usuario.nome,
          venda.partner.name,
          venda.created_at.strftime("%d/%m/%Y %H:%M"),
          venda.status_desc.error_description_pt,
          venda.produto_id_parceiro,
          venda.product_id,
          venda.product_nome,
          venda.agent_id,
          venda.store_id,
          venda.seller_id,
          venda.terminal_id,
          venda.client_msisdn,
          moeda_csv(helper.number_to_currency(venda.valor_original, :unit => "")),
          moeda_csv(helper.number_to_currency(venda.desconto_aplicado, :unit => "")),
          moeda_csv(helper.number_to_currency(porcentagem, :unit => "")),
          moeda_csv(helper.number_to_currency(venda.value, :unit => "")),
        ]
      end
    end
  end

  def update_product
    if self.product.present? && self.product_nome.blank?
      Venda.where(id: self.id).update_all(product_nome: self.product.description, product_id: self.product.id)
    end
  end

  def product_nome
    self.update_product if super.blank?
    super
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
    ReturnCodeApi.where(return_code: self.status, partner_id: self.partner_id).first || ReturnCodeApi.new(error_description_pt: "Status não localizado")
  rescue
    ReturnCodeApi.new(error_description_pt: "Status não localizado")
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
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.com_acesso(usuario_logado)
    end
    vendas = vendas.where(status: ReturnCodeApi.all.map{|r| r.return_code } )
    vendas.sum(:valor_original)
  end

  def self.total_lucros_acesso(usuario_logado, vendas_filtrada=nil)
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.com_acesso(usuario_logado)
    end
    vendas = vendas.where(status: ReturnCodeApi.all.map{|r| r.return_code } )
    vendas.sum(:desconto_aplicado)
  end

  def sucesso?
    ReturnCodeApi.where(return_code: self.status, sucesso: true, partner_id: self.partner_id).count > 0
  end

  def self.fazer_venda(params, usuario, slug_parceiro, ip)
    slug_parceiro = slug_parceiro.downcase.strip
    self.send("venda_#{slug_parceiro}", params, usuario, ip)
  end

  def request_id
    if super.present?
      return super
    end

    self.response_get.scan(/RequestId.*?RequestId>/).first.scan(/>.*?</).first.scan(/\d/).join("") rescue ""
  end

  def carregamento_venda_zaptv
    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first
    if Rails.env == "development"
      url = "#{parametro.url_integracao_desenvolvimento}/carregamento/#{self.request_id}"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      url = "#{parametro.url_integracao_producao}/carregamento/#{self.request_id}"
      api_key = parametro.api_key_zaptv_producao
    end

    begin
      if self.request_id.present?
        res = HTTParty.get(
          url, 
          headers: {
            "apikey" => api_key,
            "Content-Type" => "application/json"
          }
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
    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url = "#{parametro.url_integracao_desenvolvimento}/carregamento/#{self.request_id}"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      url = "#{parametro.url_integracao_producao}/carregamento/#{self.request_id}"
      api_key = parametro.api_key_zaptv_producao
    end

    begin
      if self.request_id.present?
        res = HTTParty.delete(
          url, 
          headers: {
            "apikey" => api_key,
            "Content-Type" => "application/json"
          }
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
      return "Delete in (#{url}) - #{err.message}"
    end
  end

  def self.desconto_venda(usuario, parceiro, valor)
    desconto = 0
    remuneracoes = Remuneracao.where(usuario_id: usuario.id)
    remuneracoes = remuneracoes.where("vigencia_inicio >= ?", Time.zone.now.beginning_of_day)
    remuneracoes = remuneracoes.where("vigencia_fim <= ?", Time.zone.now.end_of_day)
    if remuneracoes.count > 0
      remuneracao = remuneracoes.first
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
    else
      desconto = parceiro.desconto
    end

    desconto_aplicado = valor.to_f * desconto.to_f / 100
    valor_original = valor
    valor = valor - desconto_aplicado

    return [desconto_aplicado, valor_original, valor]
  end

  def self.venda_zaptv(params, usuario, ip)
    parceiro = Partner.where("lower(slug) = 'zaptv'").first
    valor = params[:valor].to_f

    desconto_aplicado, valor_original, valor = desconto_venda(usuario, parceiro, valor)
    
    parametro = Parametro.where(partner_id: parceiro.id).first

    raise "Saldo insuficiente para recarga" if usuario.saldo < valor
    raise "Parceiro não localizado" if parceiro.blank?
    raise "Parâmetros não localizados" if parametro.blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o telemovel" if params[:zaptv_cartao].blank?
    raise "Olá #{usuario.nome}, você precisa selecionar o sub-agente no seu cadastro. Entre em contato com o seu administrador" if usuario.sub_agente.blank?

    telefone = params[:zaptv_cartao]
    request_id = Time.now.strftime("%d%m%Y%H%M%S")

    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}/carregamento"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}/carregamento"
      api_key = parametro.api_key_zaptv_producao
    end

    raise "Produto não selecionado" if params[:zaptv_produto_id].blank?
    product_id = params[:zaptv_produto_id].split("-").first
    produto = Produto.find(product_id)

    body_send = {
      :price => valor_original, 
      :product_code => produto.produto_id_parceiro, #produto importado zap
      :product_quantity => 1, 
      :source_reference => request_id, #meu código 
      :zappi => telefone #Iremos receber este numero
    }.to_json


    res = HTTParty.post(
      host, 
      headers: {
        "apikey" => api_key,
        "Content-Type" => "application/json"
      },
      :body => body_send
    )

    venda = Venda.new(produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.produto_id, product_nome: produto.description, agent_id: parametro.zaptv_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, request_id: request_id, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
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

      lancamento = Lancamento.where(nome: "Compra de crédito ou recarga").first
      lancamento = Lancamento.first if lancamento.blank?

      ContaCorrente.create!(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: banco.id,
        partner_id: parceiro.id,
        iban: iban
      )
    end

    return venda
  end

   def status_movicel
    return if self.partner.name.downcase != "movicel"

    require 'openssl'

    parceiro = Partner.where("lower(slug) = 'movicel'").first
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url_service = parametro.url_integracao_desenvolvimento
      agent_key = parametro.agent_key_movicel_desenvolvimento
      user_id = parametro.user_id_movicel_desenvolvimento
    else
      url_service = parametro.url_integracao_producao
      agent_key = parametro.agent_key_movicel_producao
      user_id = parametro.user_id_movicel_producao
    end

    request_id = self.request_id

    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
    # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
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
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryTransaction',
      },
      :body => body
    )

    if (200...300).include?(request.code.to_i)
      # return request.body
      return Nokogiri::XML(request.body).children.children.children.children.children.children.text rescue nil
      # return "#{request_id} - #{Nokogiri::XML(request.body).children.children.children.children.children.text}" rescue nil
    end
  end

  def self.venda_movicel(params, usuario, ip)
    parceiro = Partner.where("lower(slug) = 'movicel'").first
    valor = params[:valor].to_i
    parametro = Parametro.where(partner_id: parceiro.id).first

    desconto_aplicado, valor_original, valor = desconto_venda(usuario, parceiro, valor)

    raise "Parâmetros não localizados" if parametro.blank?
    raise "Saldo insuficiente para recarga" if usuario.saldo < valor
    raise "Parceiro não localizado" if parceiro.blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o telemóvel" if params[:movicel_telefone].blank?
    raise "Olá #{usuario.nome}, você precisa selecionar o subagente no seu cadastro. Entre em contato com o Administrador." if usuario.sub_agente.blank?

    telefone = params[:movicel_telefone]

    raise "Produto não selecionado" if params[:movicel_produto_id].blank?
    product_id = params[:movicel_produto_id].split("-").first
    produto = Produto.find(product_id)

    require 'openssl'

    if Rails.env == "development"
      url_service = parametro.url_integracao_desenvolvimento
      agent_key = parametro.agent_key_movicel_desenvolvimento
      user_id = parametro.user_id_movicel_desenvolvimento
    else
      url_service = parametro.url_integracao_producao
      agent_key = parametro.agent_key_movicel_producao
      user_id = parametro.user_id_movicel_producao
    end

    #producao

    #homologacao
    # agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    # url_service = "http://wsqa.movicel.co.ao:10071"

    msisdn = telefone
    request_id = Time.now.strftime("%d%m%Y%H%M%S")

    # debugger
    cripto = "AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto"
    Rails.logger.info "=========[cripto]========"
    pass = `#{cripto}`
    Rails.logger.info "=========[cripto]========"

    # cripto = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
    # Rails.logger.info += "=========[cripto]========"
    # pass = `#{cripto}`
    # Rails.logger.info += "=========[cripto]========"

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
    uri = URI.parse(URI.escape(url))
    begin
      request = HTTParty.post(uri, 
        headers: {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup',
        },
        timeout: 100,
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
        uri = URI.parse(URI.escape(url))
        begin
          request = HTTParty.post(uri, 
            headers: {
              'Content-Type' => 'text/xml;charset=UTF-8',
              'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup',
            },
            timeout: 100,
            body: body
          )
          
          response_get += "=========[Topup - #{Time.zone.now.to_s} - Tempo de envio: #{Time.zone.now - data_envio}]========"
          response_get += request.body
          response_get += "=========[Topup]========"
          Rails.logger.info response_get

          Rails.logger.info "========[Confirmação enviada para operadora Movicel]=========="

          last_request = request.body

          venda = Venda.new(produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.produto_id, product_nome: produto.description, agent_id: parametro.movicel_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, request_id: request_id, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
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

            lancamento = Lancamento.where(nome: "Compra de crédito ou recarga").first
            lancamento = Lancamento.first if lancamento.blank?

            ContaCorrente.create!(
              usuario_id: usuario.id,
              valor: "-#{valor}",
              observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
              lancamento_id: lancamento.id,
              banco_id: banco.id,
              partner_id: parceiro.id,
              iban: iban
            )
          end

          return venda
        rescue Exception => err
          url = "#{url_service}/DirectTopupService/Topup/"
          payload = {
            headers: {
              'Content-Type' => 'text/xml;charset=UTF-8',
              'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup',
            },
            timeout: 100,
            body: body
          }
          raise "Erro ao enviar dados para api - URL = #{url} - payload = #{payload} - Erro = #{err.message} - backtrace = #{err.backtrace}"
        end
      else
        return_message = request.body.scan(/<ReturnMessage.*?ReturnMessage>/)
        if return_message.present?
          return_message = return_message.first.gsub(/<[^>]*>/, "") rescue return_message
          raise "Erro no envio do pedido ou resposta da  - (#{return_message})"
        end
        raise "Erro no envio do pedido ou resposta da operadora - Timeout"
      end
    rescue Exception => err
      url = "#{url_service}/DirectTopupService/Topup/"
      payload = {
        headers: {
          'Content-Type' => 'text/xml;charset=UTF-8',
          'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup',
        },
        timeout: 100,
        body: body
      }
      raise "Erro ao enviar dados para api - URL = #{url} - payload = #{payload} - Erro = #{err.message} - backtrace = #{err.backtrace}"
    end
  end

  def status_dstv
    return if self.partner.name.downcase != "dstv"
    
    #TODO fazer
    return 0
  end

  def self.venda_dstv(params, usuario, ip)
    parceiro = Partner.where("lower(slug) = 'dstv'").first
    valor = params[:valor].to_i
    parametro = Parametro.where(partner_id: parceiro.id).first

    desconto_aplicado, valor_original, valor = desconto_venda(usuario, parceiro, valor)

    raise "Parâmetros não localizados" if parametro.blank?
    raise "Saldo insuficiente para recarga" if usuario.saldo < valor
    raise "Parceiro não localizado" if parceiro.blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o número do cliente/customer number" if params[:dstv_customer_number].blank?
    raise "Talão p/SMS" if params[:talao_sms].blank?
    raise "Olá #{usuario.nome}, você precisa selecionar o subagente no seu cadastro. Entre em contato com o Administrador." if usuario.sub_agente.blank?
    raise "Produto não selecionado" if params[:dstv_produto_id].blank?

    product_id = params[:dstv_produto_id].split("-").first
    produto = Produto.find(product_id)

    require 'openssl'

    transaction_number = (Venda.order("id desc").first.id + 1)

    if Rails.env == "development"
      url_service = parametro.url_integracao_desenvolvimento
      data_source = parametro.data_source_dstv_desenvolvimento
      payment_vendor_code = parametro.payment_vendor_code_dstv_desenvolvimento
      vendor_code = parametro.vendor_code_dstv_desenvolvimento
      agent_account = parametro.agent_account_dstv_desenvolvimento
      currency = parametro.currency_dstv_desenvolvimento
      product_user_key = parametro.product_user_key_dstv_desenvolvimento
      mop = parametro.mop_dstv_desenvolvimento # mop = "CASH, MOBILE or ATM "
      agent_number = parametro.agent_number_dstv_desenvolvimento #122434345
    else
      url_service = parametro.url_integracao_producao
      data_source = parametro.data_source_dstv_producao
      payment_vendor_code = parametro.payment_vendor_code_dstv_producao
      vendor_code = parametro.vendor_code_dstv_producao
      agent_account = parametro.agent_account_dstv_producao
      currency = parametro.currency_dstv_producao
      product_user_key = parametro.product_user_key_dstv_producao
      mop = parametro.mop_dstv_producao # mop = "CASH, MOBILE or ATM "
      agent_number = parametro.agent_number_dstv_producao #122434345
    end

    request_send = ""
    response_get = ""
    last_request = ""

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\" xmlns:sel1=\"http://datacontracts.multichoice.co.za/SelfCare\">
        <soapenv:Header/>
        <soapenv:Body>
        <sel:AgentSubmitPayment>
          <sel:agentPaymentRequest>
            <sel1:paymentVendorCode>#{payment_vendor_code}</sel1:paymentVendorCode>
            <sel1:transactionNumber>#{transaction_number}</sel1:transactionNumber>
            <sel1:dataSource>#{data_source}</sel1:dataSource>
            <sel1:customerNumber>#{params[:dstv_customer_number]}</sel1:customerNumber>
            <sel1:amount>#{valor_original}</sel1:amount>
            <sel1:invoicePeriod>1</sel1:invoicePeriod>
            <sel1:currency>AOA</sel1:currency>
            <sel1:paymentDescription>Pagasó Payment System</sel1:paymentDescription>
            <sel1:methodofPayment>CASH</sel1:methodofPayment>
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

    request_send += "=========[SubmitPaymentBySmartCard]========"
    request_send += body
    request_send += "=========[SubmitPaymentBySmartCard]========"

    #http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc?wsdl
    url = "#{url_service}/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://services.multichoice.co.za/SelfCare/ISelfCareService/AgentSubmitPayment",
      },
      :body => body
    )
    
    response_get += "=========[SubmitPaymentBySmartCard]========"
    response_get += request.body
    response_get += "=========[SubmitPaymentBySmartCard]========"

    last_request = request.body
    
    venda = Venda.new(produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.produto_id, product_nome: produto.description, agent_id: parametro.dstv_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, request_id: transaction_number, client_msisdn: params[:dstv_customer_number], usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    venda.request_send = request_send
    venda.response_get = response_get
    erro_message = last_request.scan(/faultstring.*?<\/faultstring/).first.scan(/>.*?</).first rescue ""

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
      status = last_request.scan(/status.*?<\/a\:status/).first.gsub(/status|\>|\<|a|\:|\//, "") rescue "false"
      venda.status = (status == "true" ? "1" : "3")
    end

    venda.save!

    if venda.sucesso?
      lancamento = Lancamento.where(nome: "Compra de crédito ou recarga").first
      lancamento = Lancamento.first if lancamento.blank?

      ContaCorrente.create!(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
        partner_id: parceiro.id,
        iban: ContaCorrente.where(usuario_id: usuario.id).first.iban
      )
    end

    return venda
  end

  def self.venda_unitel(params, usuario, ip)
    parceiro = Partner.where("lower(slug) = 'unitel'").first
    valor = params[:valor].to_i
    parametro = Parametro.where(partner_id: parceiro.id).first
    desconto_aplicado, valor_original, valor = desconto_venda(usuario, parceiro, valor)

    raise "Parâmetros não localizados" if parametro.blank?
    raise "Saldo insuficiente para recarga" if usuario.saldo < valor
    raise "Parceiro não localizado" if parceiro.blank?
    raise "Produto não selecionado" if params[:unitel_produto_id].blank?
    raise "Selecione o valor" if params[:valor].blank?
    raise "Digite o telemóvel" if params[:unitel_telefone].blank?
    raise "Olá #{usuario.nome}, você precisa selecionar o subagente no seu cadastro. Entre em contato com o Administrador." if usuario.sub_agente.blank?

    product_id = params[:unitel_produto_id].split("-").first
    produto = Produto.find(product_id)
    telefone = params[:unitel_telefone]

    venda = Venda.new(produto_id_parceiro: produto.produto_id_parceiro, product_id: produto.produto_id, product_nome: produto.description, agent_id: parametro.unitel_agente_id, value: valor, desconto_aplicado: desconto_aplicado, valor_original: valor_original, client_msisdn: telefone, usuario_id: usuario.id, partner_id: parceiro.id)
    venda.responsavel = usuario
    venda.save!

    venda.store_id = usuario.sub_agente.store_id_parceiro
    venda.seller_id = usuario.sub_agente.seller_id_parceiro
    venda.terminal_id = usuario.sub_agente.terminal_id_parceiro

    sequence = UnitelSequence.order("id desc").first
    if sequence.blank?
      sequence_id = 1
    else
      sequence_id = sequence.sequence_id + 1
    end
    
    if Rails.env == "development"
      make_sale_endpoint = "#{parametro.url_integracao_desenvolvimento}/spgw/V2/makeSale"
    else
      make_sale_endpoint = "#{parametro.url_integracao_producao}/spgw/V2/makeSale"
    end

    # ./chaves/unitel_recarga.sh '7' '9' '114250' '' '' '' '500' '244998524570' 'https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale'
    
    if Rails.env == "development"
      dados_envio = "./chaves/unitel_recarga.sh '#{sequence_id}' '#{venda.produto_id_parceiro}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor_original}' '#{venda.client_msisdn}' '#{make_sale_endpoint}'"
    else
      dados_envio = "./chaves/unitel_recarga_producao.sh '#{sequence_id}' '#{venda.produto_id_parceiro}' '#{venda.agent_id}' '#{venda.store_id}' '#{venda.seller_id}' '#{venda.terminal_id}' '#{valor_original}' '#{venda.client_msisdn}' '#{make_sale_endpoint}'"
    end

    retorno = `#{dados_envio}`
    venda.request_send, venda.response_get = retorno.split(" --- ")

    venda.request_send = "#{venda.request_send} ========== #{dados_envio}"

    venda.status = venda.response_get_parse["statusCode"] rescue "3"
    venda.save!

    UnitelSequence.create(sequence_id: sequence_id, venda_id: venda.id)

    if venda.sucesso?
      lancamento = Lancamento.where(nome: "Compra de crédito ou recarga").first
      lancamento = Lancamento.first if lancamento.blank?

      ContaCorrente.create!(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de regarga dia #{Time.zone.now.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        partner_id: parceiro.id,
        banco_id: ContaCorrente.where(usuario_id: usuario.id).first.banco_id,
        iban: ContaCorrente.where(usuario_id: usuario.id).first.iban
      )
    end

    return venda
  end

  def lucro
    
    venda.valor_original
    venda.desconto_aplicado 
    venda.lucro
    venda.value

  end

  private
    def self.moeda_csv(valor)
      valor.gsub(".", "").gsub(",", ".")
    end

    def self.helper
      @helper ||= Class.new do
        include ActionView::Helpers::NumberHelper
      end.new
    end
end
