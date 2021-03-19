json.extract! banco, :id, :nome, :sigla, :morada_sede, :telefone_sede, :morada_escritorio, :telefone_escritorio, :website, :email, :logomarca, :iban, :conta_bancaria, :ordem_prioridade, :whatsapp, :status_banco_id, :created_at, :updated_at
json.url banco_url(banco, format: :json)
