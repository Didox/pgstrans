require 'test_helper'

# UNITEL
class RequestTestUnitel < ActiveSupport::TestCase

    test "Tentando buscar produtos da UNITEL pela API Pagasó com o usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/recarga/unitel-produtos.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Tentando buscar produtos da UNITEL pela API Pagasó com o USUÁRIO LOGADO" do
        uri = URI.parse("#{Helper.url}/api/recarga/unitel-produtos.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code

        conteudos = response.parsed_response

        assert conteudos.length > 0

        conteudo = conteudos[0]

        assert conteudo["subtipo"].present?
        assert conteudo["produtos"].present?

        produto = conteudo["produtos"][0]
        assert produto["id"].present?
        assert produto["nome"].present?
        assert produto["valor"].present?

        puts("\nTeste de produtos com o usuário autenticado: #{conteudo.inspect}]")
    end
end