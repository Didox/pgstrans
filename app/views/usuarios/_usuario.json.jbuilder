json.extract! usuario, :id, :nome, :email, :senha, :morada, :bairro, :municipio_id, :provincia_id, :industry_id; :uni_pessoal_empresa_id, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
