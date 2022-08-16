json.extract! produto, :id, :description, :partner_id, :status_produto_id, :valor_compra_telemovel, :valor_compra_site, 
:valor_compra_pos, :valor_compra_tef, :mensagem_cupom_venda, 
:mensagem_cupom_venda, :moeda_id, :data_vigencia, :nome_comercial, :parameter_code_africell, :created_at, :updated_at
json.url produto_url(produto, format: :json)
