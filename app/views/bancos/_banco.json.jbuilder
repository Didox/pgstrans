json.extract! banco, :id, :nome, :sigla, :morada_sede, :telefone_sede, :fax_sede, :morada_escritorio, :telefone_escritorio, :fax_escritorio, :website, :email, :logomarca, :iban, :conta_bancaria, :created_at, :updated_at
json.url banco_url(banco, format: :json)
