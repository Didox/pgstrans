namespace :jobs do
  desc "Importa rel ZAPTv"
  task importa_dados_zaptv: :environment do
    partner = Partner.where(slug: "ZAPTv").first
    ###### Entender se realmente não precisamos passar este id
    # partner.store_id_parceiro # "115356"
    ############################################################

    day = Time.zone.now
    (Time.zone.now.beginning_of_month.day .. Time.zone.now.day).each do |d|
      day = day.change(day: d) 
      host = "http://10.151.59.196"
      url = "#{host}/ao/echarge/pagaso/dev/carregamento/report/#{day.strftime("%Y-%m-%d")}"
      
      puts ":::: (#{url}) ::::"

      next if RelatorioConciliacaoZaptv.where(url: url).count > 0

      res = HTTParty.get(
        url, 
        headers: {
          "apikey" => "b65298a499c84224d442c6a680d14b8e",
          "Content-Type" => "application/json"
        }
      )

      if (200..300).include?(res.code)
        dados = JSON.parse(res.body)
        dados.each do |dado|
          rel = RelatorioConciliacaoZaptv.create(
            partner_id: partner.id,
            url: url,
            operation_code: dado["operation_code"],
            source_reference: dado["source_reference"],
            product_code: dado["product_code"],
            quantity: dado["quantity"],
            date_time: dado["datetime"],
            type_data: dado["type"],
            total_price: dado["total_price"],
            status: dado["status"],
            unit_price: dado["unit_price"]
          )

          puts ":::: Rel criado (#{rel.id}) ::::"
        end
      else
        puts ":::: Não encontrado (#{res.body}) ::::"
      end

    end
  end

  desc "EXECUTA REST API TEST"
  task importa_produtos_zap: :environment do
    res = HTTParty.get(
      "http://10.151.59.196/ao/echarge/pagaso/dev/portfolio/menu", 
      headers: {
        apikey: "b65298a499c84224d442c6a680d14b8e"
      }
    )

    if (200...300).include?(res.code)
      partner = Partner.where(slug: "ZAPTv").first
      dados = JSON.parse(res.body)
      dados["Products"].each do |p_hash|
        produtos = Produto.where(produto_id_parceiro: p_hash["code"], partner_id: partner.id)
        if produtos.count == 0
          produto = Produto.new
          produto.produto_id_parceiro = p_hash["code"]
          produto.partner_id = partner.id
        else
          produto = produtos.first
        end

        produto.description = p_hash["description"]
        produto.valor_minimo_venda_site = p_hash["price"]
        # TODO ::: Verificar se um dia iremos utilizar :::
        # produto.name = p_hash["recomended_quantity"]
        # produto.name = p_hash["unit"]
        # produto.name = p_hash["unit_pl"]
        produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{p_hash["currency"]}')").first.id
        produto.subtipo = p_hash["technology"]
        produto.status_produto = StatusProduto.where(nome: "Ativo").first

        produto.save
      end
    end
  end

  desc "EXECUTA SOAP API TEST DSTV"
  task importa_produtos_dstv: :environment do
    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:sel=\"http://services.multichoice.co.za/SelfCare\">
         <soapenv:Header/>
         <soapenv:Body>
            <sel:GetAvailableProducts>
               <!--Optional:-->
               <sel:dataSource>Angola</sel:dataSource>
               <!--Optional:-->
               <sel:customerNumber>122364781</sel:customerNumber>
               <!--Optional:-->
               <sel:BusinessUnit>DStv</sel:BusinessUnit>
               <!--Optional:-->
               <sel:VendorCode>PagasoDStv</sel:VendorCode>
               <!--Optional:-->
               <sel:language>?</sel:language>
               <!--Optional:-->
               <sel:ipAddress>?</sel:ipAddress>
               <!--Optional:-->
               <sel:interfaceType>?</sel:interfaceType>
            </sel:GetAvailableProducts>
         </soapenv:Body>
      </soapenv:Envelope>
    "

    url = "http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://services.multichoice.co.za/SelfCare/ISelfCareService/GetAvailableProducts',
      },
      :body => body)
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        puts "=========================================="
        puts request.body
        puts "=========================================="

        partner = Partner.where(slug: "DSTv").first
        
        xml_doc = Nokogiri::XML(request.body)
        itens = xml_doc.child.children[0].children[0].children[0].children
        itens.each do |item|

          produto_id_parceiro = 0
          descricao = ""
          price = 0
          currency = ""
          item.children.each do |campo|
            if campo.name == "productCode"
              produto_id_parceiro = campo.content
            elsif campo.name == "currency"
              currency = campo.content
            elsif campo.name == "productDesc"
              descricao = campo.content
            elsif campo.name == "productPrice"
              price = campo.content.to_f
            end
          end

          produtos = Produto.where(produto_id_parceiro: produto_id_parceiro, partner_id: partner.id)
          if produtos.count == 0
            produto = Produto.new
            produto.produto_id_parceiro = produto_id_parceiro
            produto.partner_id = partner.id
          else
            produto = produtos.first
          end

          produto.description = descricao

          produto.valor_compra_telemovel = price
          produto.valor_compra_site = price
          produto.valor_compra_pos = price
          produto.valor_compra_tef = price
          produto.valor_minimo_venda_telemovel = price
          produto.valor_minimo_venda_site = price
          produto.valor_minimo_venda_pos = price
          produto.valor_minimo_venda_tef = price


          produto.moeda_id = Moeda.where("lower(simbolo) = lower('#{currency}')").first.id
          produto.status_produto = StatusProduto.where(nome: "Ativo").first

          produto.save!
        end

        puts "=========================================="
      end
    end
  end

end
