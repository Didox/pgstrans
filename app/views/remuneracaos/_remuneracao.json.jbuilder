json.extract! remuneracao, :id, :nome, :usuario_id, :produto_id, :valor_venda_final_telemovel, :valor_venda_final_site, :valor_venda_final_pos, :valor_venda_final_tef, :vigencia_inicio, :vigencia_fim, :created_at, :updated_at
json.url remuneracao_url(remuneracao, format: :json)
