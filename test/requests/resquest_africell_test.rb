require 'test_helper'

# AFRICELL
class RequestTestAFricell < ActiveSupport::TestCase

    test "Tentando buscar produtos da AFRICELL pela API Pagasó com o usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/recarga/AFRICELL-produtos.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Testando e obtendo token no login API" do
        token = Helper.token_login
        assert token.present?
    end

    test "Tentando buscar produtos da AFRICELL pela API Pagasó com o USUÁRIO LOGADO" do
        uri = URI.parse("#{Helper.url}/api/recarga/africell-produtos.json")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['authorization'] = "Bearer #{Helper.token_login}"
        response = http.request(request)
        assert response.code == "200"

        conteudos = JSON.parse(response.body)

        assert conteudos.length > 0

        conteudo = conteudos[0]

        assert conteudo["produtos"].present?

        produto = conteudo["produtos"][0]

        puts("\nTeste de produtos com o usuário autenticado: #{produto.inspect}]")

        puts "\n===============[Teste de produtos com o usuário autenticado: #{produto.inspect}]===============\n"

        assert produto["id"].present?
        assert produto["nome"].present?
        assert produto["valor"].present?
    end
    
end