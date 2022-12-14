require 'test_helper'

# DSTV
class RequestTestDstv < ActiveSupport::TestCase

    test "Tentando buscar produtos da DSTV pela API Pagasó com o usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/recarga/dstv-produtos.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Testando e obtendo token login API" do
        token = Helper.token_login
        assert token.present?
    end

    test "Tentando buscar produtos da DSTV pela API Pagasó com o USUÁRIO LOGADO" do
        uri = URI.parse("#{Helper.url}/api/recarga/dstv-produtos.json")
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

        puts "\n===============[Teste de produtos com o usuário autenticado: #{produto.inspect}]==============="

        assert produto["id"].present?
        assert produto["valor"].present?
    end

    test "Tentando buscar produtos da DSTV com o usuário logado" do
        uri = URI.parse("#{Helper.url}/api/recarga/dstv-produtos.json")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['authorization'] = "Bearer #{Helper.token_login}"
        response = http.request(request)
        assert response.code == "200"

        conteudos = JSON.parse(response.body)

        assert conteudos.length > 0

        produto = conteudos[0]

        puts("\nTeste de produtos com o usuário autenticado: #{produto.inspect}]\n")

        puts "\n===============[Lista de produtos DSTV com o usuário autenticado: #{produto.inspect}]==============="

        assert produto["id"].present?
        assert produto["valor"].present?
    end
    
end
