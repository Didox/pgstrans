class Partner < ApplicationRecord
  include PermissionamentoDados

  has_many :return_code_api
  validates :name, presence: true, uniqueness: true
  belongs_to :status_parceiro
  default_scope { order(order: :asc) }

  STORE_ID_ZAP_PARCEIRO = "115356"

  def usuarios_operadoras_ativas
    @usuarios_operadoras_ativas ||= self.usuarios.to_s.split(",").map{|s|s.strip}
    return @usuarios_operadoras_ativas
  end

  def self.menu_home
    Partner.where(status_parceiro_id: StatusParceiro::ATIVO, portfolio_venda: true)
  end

  def total_vendas(usuario_logado, vendas_filtrada=nil)
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.all
    end
    vendas = vendas.where(partner_id: self.id, status: ReturnCodeApi.where(partner_id: self.id).map{|r| r.return_code } )
    vendas = vendas.where(usuario_id: usuario_logado.id)
    vendas.sum(:value)
  end

  def total_vendas_acesso(usuario_logado, vendas_filtrada=nil)
    unless vendas_filtrada.nil?
      vendas = vendas_filtrada.clone
    else
      vendas = Venda.com_acesso(usuario_logado)
    end
    vendas = vendas.where(partner_id: self.id, status: ReturnCodeApi.where(partner_id: self.id).map{|r| r.return_code } )
    vendas.sum(:value)
  end

  def cor
    case self.slug
    when "Unitel"
      return "#ED7018"
    when "Movicel"
      return "#CC031B"
    when "DSTv"
      return "#5991B1"
    when "ZAPTv"
      return "#FDD500"
    end
  end

  def nome_operadora(telefone)
    return BantuBet.busca_nome(telefone) if self.slug == "bantubet"
    return Zap.busca_nome(telefone) if self.slug == "zaptv"
    raise "Operadora #{this.slug} não configurada para busca de nome do cliente na operadora"
  end

  def self.find_by_slug(slug)
    slug = slug.to_s.downcase.strip
    Partner.where("lower(slug) = ?", slug).first
  end

  def self.africell
    Partner.find_by_slug('africell')
  end

  def self.elephantbet
    Partner.find_by_slug('elephantbet')
  end

  def self.bantubet
    Partner.find_by_slug('bantubet')
  end

  def self.dstv
    Partner.find_by_slug('dstv')
  end

  def self.ende
    Partner.find_by_slug('ende')
  end

  def self.movicel
    Partner.find_by_slug('movicel')
  end

  def self.zaptv
    Partner.find_by_slug('zaptv')
  end

  def self.unitel
    Partner.find_by_slug('unitel')
  end

  def self.zapfibra
    Partner.find_by_slug('zapfibra')
  end

  def self.proxypay
    Partner.find_by_slug('proxypay')
  end

  def valor_total_original_sql(params={}, usuario_logado)
    vendas = Venda.com_acesso(usuario_logado).where(partner_id: self.id, status: ReturnCodeApi.where(partner_id: self.id, sucesso: true).map{|r| r.return_code })
    vendas = vendas.joins("inner join usuarios on usuarios.id = vendas.usuario_id")
    vendas = vendas.joins("inner join partners on partners.id = vendas.partner_id")

    vendas = vendas.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    
    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      vendas = vendas.where("usuarios.status_cliente_id = ?", params[:status])
    end

    vendas = vendas.where("vendas.updated_at >= ?", SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)) if params[:data_inicio].present?
    vendas = vendas.where("vendas.updated_at <= ?", SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)) if params[:data_fim].present?
    vendas
  end

  def valor_total_original(params={}, usuario_logado)
    vendas = valor_total_original_sql(params, usuario_logado)
    vendas.sum(:valor_original)
  end

  def desconto_total_aplicado(params={}, usuario_logado)
    vendas = valor_total_original_sql(params, usuario_logado)
    vendas.sum(:desconto_aplicado)
  end

  def valor_total_vendido(params={}, usuario_logado)
    vendas = valor_total_original_sql(params, usuario_logado)
    vendas.sum(:value)
  end

  def importa_produtos!(categoria)
    if(self.slug.downcase.scan(/zap/))
      Zap.importa_produtos(self, categoria)
    else
      self.slug.capitalize.constantize.importa_produtos(categoria)
    end
  end

  def importa_dados!(categoria = nil)
    if(self.slug.downcase.scan(/zap/))
      Zap.importa_dados!(self, categoria)
    else
      self.slug.capitalize.constantize.importa_dados!
    end
  end

  def saldo_atual_movicel(ip="?")
    parceiro = Partner.movicel
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      url_service = parametro.get.url_integracao_desenvolvimento
      agent_key = parametro.get.agent_key_movicel_desenvolvimento
    else
      url_service = parametro.get.url_integracao_producao
      agent_key = parametro.get.agent_key_movicel_producao
    end

    host = url_service.to_s.gsub(/o\:.*/, "o")

    require 'openssl'

    user_id = "TivTechno"
    request_id = Time.zone.now.strftime("%d%m%Y%H%M%S")

    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`
    # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
    pass = pass.strip

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\">
        <soapenv:Header>
          <int:QueryBalanceReqHeader>
              <mid:RequestId>#{request_id}</mid:RequestId>
              <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
              <!--Optional:-->
              <mid:SourceSystem>#{user_id}</mid:SourceSystem>
              <mid:Credentials>
                <mid:User>#{user_id}</mid:User>
                <mid:Password>#{pass}</mid:Password>
              </mid:Credentials>
              <!--Optional:-->
              <mid:Attributes>
                <!--Zero or more repetitions:-->
                <mid:Attribute>
                    <mid:Name>?</mid:Name>
                    <mid:Value>?</mid:Value>
                </mid:Attribute>
              </mid:Attributes>
          </int:QueryBalanceReqHeader>
        </soapenv:Header>
        <soapenv:Body>
          <int:QueryBalanceReq>
              <!--Optional:-->
              <int:QueryBalanceReqBody/>
          </int:QueryBalanceReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "

    Rails.logger.info "========[Enviando consulta de saldo operadora Movicel]=========="
    
    url = "#{url_service}/DirectTopupService/Topup/"
    uri = URI.parse(URI::Parser.new.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => "http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/QueryBalance",
      },
      :body => body,
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )
    Rails.logger.info "========[Consulta de saldo operadora Movicel enviado]=========="

    if (200...300).include?(request.code.to_i)
      saldo = Nokogiri::XML(request.body).children.children.children.children.children.children.text
      SaldoParceiro.create!(saldo: saldo, partner_id: self.id, log: "Saldo atualizado - code=#{request.code} - body=#{request.body} - host=#{host}")
    else
      SaldoParceiro.create!(saldo: 0, partner_id: self.id, log: "Erro ao atualizar saldo - code=#{request.code} - body=#{request.body} - host=#{host}")
    end
  rescue Exception => e
    SaldoParceiro.create!(saldo: 0, partner_id: self.id, log: "Erro ao atualizar saldo - #{e.message} - #{e.backtrace}")
  end

  def ultimo_saldo
    return SaldoParceiro.where(partner_id: self.id).reorder("id desc").limit(1).first if SaldoParceiro.where(partner_id: self.id).count > 0
    SaldoParceiro.new
  rescue
    SaldoParceiro.new
  end

  def saldo_atual_zapfibra(ip="?")
    self.saldo_atual_zaptv(ip)
  end

  def saldo_atual_zaptv(ip="?")
    parceiro = Partner.zaptv
    parametro = Parametro.where(partner_id: parceiro.id).first

    if Rails.env == "development"
      host = "#{parametro.get.url_integracao_desenvolvimento}"
      api_key = parametro.get.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.get.url_integracao_producao}"
      api_key = parametro.get.api_key_zaptv_producao
    end

    host = host.gsub("/carregamento",'')
    url = "#{host}/saldo?code=#{STORE_ID_ZAP_PARCEIRO}"
    Rails.logger.info "========[Enviando consulta de saldo operadora Zap #{url}]=========="
    request = HTTParty.get(
      url, 
      headers: {
        "apikey" => api_key,
        "Content-Type" => "application/json"
      },
      timeout: DEFAULT_TIMEOUT.to_i.seconds
    )
    Rails.logger.info "========[Consulta de saldo operadora Zap enviada #{url}]=========="

    if (200..300).include?(request.code)
      SaldoParceiro.create!(saldo: JSON.parse(request.body)["saldo"], partner_id: self.id, log: "Saldo atualizado - code=#{request.code} - body=#{request.body} - host=#{host} - api_key=#{api_key}")
    else
      SaldoParceiro.create!(saldo: 0, partner_id: self.id, log: "Erro ao atualizar saldo - code=#{request.code} - body=#{request.body} - host=#{host} - api_key=#{api_key}")
    end
  rescue Exception => e
    SaldoParceiro.create!(saldo: 0, partner_id: self.id, log: "Erro ao atualizar saldo - #{e.message} - #{e.backtrace} ")
  end

  def saldo_atual_dstv(ip="?")
    Dstv.consulta_saldo(ip)
  end

  def saldo_atual_africell(ip="")
    Africell.consulta_saldo
  end

  def atualiza_saldo!(ip="?")
    return self.send("saldo_atual_#{self.slug.downcase}", ip)
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

  before_validation do
    self.slug = self.name.parameterize.downcase if self.slug.blank?
  end
end
