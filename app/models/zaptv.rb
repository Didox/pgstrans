class Zaptv
  def self.importa_produtos
    partner = Partner.where(slug: "ZAPTv").first

    parametro = Parametro.where(partner_id: partner.id).first

    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}/portfolio"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}/portfolio"
      api_key = parametro.api_key_zaptv_producao
    end

    res = HTTParty.get(
      host, 
      headers: {
        apikey: api_key
      }
    )

    if (200...300).include?(res.code)
      dados = JSON.parse(res.body)
      dados.each do |p_hash|
        produto = Produto.new
        produto.produto_id_parceiro = p_hash["code"]
        produto.partner_id = partner.id
        produto.description = p_hash["description"]
        produto.valor_compra_site = p_hash["price"]
        produto.valor_compra_telemovel = p_hash["price"]
        produto.subtipo = p_hash["technology"]
        produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{currency}')").first.id rescue Moeda.where(simbolo: "Kz").first.id
        produto.status_produto = StatusProduto.where(nome: "Inativo").first
        produto.save
      end
    else
      raise "API ZAPTV Não retornou 200, sem dados para atualização"
    end

    item = UltimaAtualizacaoProduto.where(partner_id: partner.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      UltimaAtualizacaoProduto.create(partner_id: partner.id)
    end
  end

  def self.importa_dados!
    partner = Partner.where(slug: "ZAPTv").first

    parametro = Parametro.where(partner_id: partner.id).first
    if Rails.env == "development"
      host = "#{parametro.url_integracao_desenvolvimento}"
      api_key = parametro.api_key_zaptv_desenvolvimento
    else
      host = "#{parametro.url_integracao_producao}"
      api_key = parametro.api_key_zaptv_producao
    end

    data = Time.zone.now - 20.days
    while data <= Time.zone.now
      url = "#{host}/carregamento/report/#{data.strftime("%Y-%m-%d")}"
      data = data + 1.day

      Rails.logger.info ":::: (#{url}) ::::"

      res = HTTParty.get(
        url, 
        headers: {
          "apikey" => api_key,
          "Content-Type" => "application/json"
        }
      )

      if (200..300).include?(res.code)
        dados = JSON.parse(res.body)
        RelatorioConciliacaoZaptv.where(url: url).destroy_all if dados.length > 0
        dados.each do |dado|
          rel = RelatorioConciliacaoZaptv.new

          rel.partner_id = partner.id
          rel.url = url
          rel.operation_code = dado["operation_code"]
          rel.source_reference = dado["source_reference"]
          rel.product_code = dado["product_code"]
          rel.quantity = dado["quantity"]
          rel.date_time = dado["datetime"]
          rel.type_data = dado["type"]
          rel.total_price = dado["total_price"]
          rel.status = dado["status"]
          rel.unit_price = dado["unit_price"]
          rel.save

          Rails.logger.info ":::: Relatório criado (#{rel.id}) ::::"
        end
      else
        Rails.logger.info ":::: Não encontrado (#{res.body}) ::::"
      end
    end

    item = UltimaAtualizacaoReconciliacao.where(partner_id: partner.id).first
    if item.present?
      item.updated_at = Time.zone.now
      item.save!
    else
      UltimaAtualizacaoReconciliacao.create(partner_id: partner.id)
    end
  end
end