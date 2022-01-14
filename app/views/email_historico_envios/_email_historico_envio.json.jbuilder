json.extract! email_historico_envio, :id, :email, :titulo, :conteudo, :usuario_id, :venda_id, :sucesso, :created_at, :updated_at
json.url email_historico_envio_url(email_historico_envio, format: :json)
