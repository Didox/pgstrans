require 'test_helper'

# ZAP Fibra
class RequestTestZapFibra < ActiveSupport::TestCase

    test "Tentando buscar produtos da ZAP Fibra pela API Pagasó com o usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/recarga/zapfibra-produtos.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Tentando buscar produtos da ZAP Fibra pela API Pagasó com o USUÁRIO LOGADO" do
        uri = URI.parse("#{Helper.url}/api/recarga/zapfibra-produtos.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code

        conteudos = response.parsed_response

        assert conteudos.length > 0

        conteudo = conteudos[0]

        assert conteudo["id"].present?
        assert conteudo["nome"].present?
        assert conteudo["valor"].present?

        puts("\nTeste de produtos com o usuário autenticado: #{conteudo.inspect}]\n")
    end    
end