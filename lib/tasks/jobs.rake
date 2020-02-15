namespace :jobs do
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
          <sel:GetProducts>
             <sel:dataSource>Angola</sel:dataSource>
             <sel:customerNumber>122364781</sel:customerNumber>
             <sel:VendorCode>PagasoDStv</sel:VendorCode>
             <sel:language>PT</sel:language>
             <sel:businessUnit>DStv</sel:businessUnit>
          </sel:GetProducts>
       </soapenv:Body>
    </soapenv:Envelope>
    "

    url = "http://uat.mcadigitalmedia.com/VendorSelfCare/SelfCareService.svc"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://services.multichoice.co.za/SelfCare/ISelfCareService/GetProducts',
      },
      :body => body)
    
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        puts "=========================================="
        puts request.body
        puts "=========================================="
      end
    end
  end

end
