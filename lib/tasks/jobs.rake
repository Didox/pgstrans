namespace :jobs do
  desc "EXECUTA SOAP API TEST"
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
        else
          produto = produtos.first
        end

        produto.name = p_hash["description"]
        produto.valor_compra_telemovel = p_hash["price"]
        # produto.name = p_hash["recomended_quantity"]
        produto.name = p_hash["unit"]
        produto.name = p_hash["unit_pl"]
        produto.name = p_hash["currency"]
        produto.name = p_hash["technology"]

        produto.save
      end
    end
  end

end
