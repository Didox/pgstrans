json.extract! modal_informativo, :id, :titulo, :mensagem, :validade_inicio, :validade_fim, :created_at, :updated_at
json.url modal_informativo_url(modal_informativo, format: :json)
