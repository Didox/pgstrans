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

          produto.responsavel = Usuario.adm
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
