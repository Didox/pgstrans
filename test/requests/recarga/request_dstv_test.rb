require 'test_helper'

# DSTV
class RequestTestDstv < ActiveSupport::TestCase

    test "Tentando buscar produtos da DSTV pela API Pagasó com o usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/recarga/dstv-produtos.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Tentando buscar produtos da DSTV pela API Pagasó com o USUÁRIO LOGADO" do
        uri = URI.parse("#{Helper.url}/api/recarga/dstv-produtos.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code

        conteudos = response.parsed_response

        assert conteudos.length > 0

        conteudo = conteudos[0]

        assert conteudo["produtos"].present?

        produto = conteudo["produtos"][0]

        puts("\nTeste de produtos com o usuário autenticado: #{produto.inspect}]")

        puts "\n===============[Teste de produtos com o usuário autenticado: #{produto.inspect}]==============="

        assert produto["id"].present?
        assert produto["valor"].present?
    end

    test "Tentando fazer recarga com usuário NÃO logado" do

        uri = URI("#{Helper.url}/api/recarga/confirma/dstv.json")
        res = HTTParty.post(uri, {
            body: {
                "transacao_smartcard": "true",
                "produto_id": "1",
                "valor": "1",
                "dstv_number": "1234"
            }
        })

        puts "=============[#{res.code}]==============="
        
        assert_equal 401, res.code
    end

    test "Tentando fazer recarga com usuário logado e com smartcard não associado" do

        uri = URI("#{Helper.url}/api/recarga/confirma/dstv.json")
        res = HTTParty.post(uri, {
            headers: {
                'authorization': "Bearer #{Helper.token_login}"
            },
            body: {
                "transacao_smartcard": "true",
                "produto_id": "1",
                "valor": "1",
                "dstv_number": "1234"
            }
        })

        assert_equal 401, res.code

        conteudo = res.parsed_response

        assert conteudo["mensagem"].present?
        assert conteudo["status"] == 401
        assert conteudo["sucesso"] == false

        puts "============[#{conteudo.inspect}]=================="
    end
   
end
