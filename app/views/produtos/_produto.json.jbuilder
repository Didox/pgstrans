json.extract! produto, :id, :description, :partner_id, :status_produto_id, :valor_compra_telemovel, :valor_compra_site, :valor_compra_pos, :valor_compra_tef, :valor_minimo_venda_telemovel, :valor_minimo_venda_site, :valor_minimo_venda_pos, :valor_minimo_venda_tef, :margem_telemovel, :margem_site, :margem_pos, :margem_tef, :mensagem_cupom_venda, :created_at, :updated_at
json.url produto_url(produto, format: :json)
