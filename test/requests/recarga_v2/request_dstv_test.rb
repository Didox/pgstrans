require 'test_helper'

# DSTV
class RequestTestDstv < ActiveSupport::TestCase

    test "Tentando fazer recarga v2 DSTV com usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/v2/recarga/confirma/dstv.json")
        res = HTTParty.post(uri)
        puts "===Tentando fazer recarga v2 DSTV com usuário NÃO logado===="
        puts "=============[#{res.code}]==============="
        
        assert_equal 401, res.code

        conteudo = res.parsed_response

        puts "===Tentando fazer recarga v2 DSTV com usuário NÃO logado===="
        puts "=========[#{conteudo}]==============="

        assert_equal conteudo["message"], "Área restrita. Digite o login e palavra-passe para entrar." 
        assert_equal conteudo["code"],  "PGS_SYS_0070"
        assert_equal conteudo["status"],  401
    end

    test "Tentando fazer recarga v2 DSTV com usuário logado, mas com parametros inválidos" do
        uri = URI("#{Helper.url}/api/v2/recarga/confirma/dstv.json")
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

        assert_equal 400, res.code
        
        conteudo = res.parsed_response

        puts "===Tentando fazer recarga v2 DSTV com usuário logado, mas com parâmetros inválidos=="
        puts "=========[#{conteudo}]=========="

        assert conteudo["message"].present?
        assert_equal conteudo["code"],  "PGS_ERRO_RECARGA_0001"
        assert_equal conteudo["status"],  400
    end

    test "Tentando fazer recarga v2 DSTV com usuário logado e com parâmetros válidos" do
        uri = URI("#{Helper.url}/api/v2/recarga/confirma/dstv.json")
        res = HTTParty.post(uri, {
            headers: {
                'authorization': "Bearer #{Helper.token_login}"
            },
            body: {
                "transacao_smartcard": "true",
                "produto_id": "129",
                "valor": "1600",
                "dstv_number": "41306400502"
            }
        })

        assert_equal 200, res.code

        conteudo = res.parsed_response

        puts "===Tentando fazer recarga v2 DSTV com usuário logado e com parâmetros válidos==="
        puts "=========[#{conteudo}]=========="

        assert conteudo["message"].present?
        assert conteudo["code"]
        assert conteudo["status"] == 401
    end

    
end
