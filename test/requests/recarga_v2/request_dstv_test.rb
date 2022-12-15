require 'test_helper'

# DSTV
class RequestTestDstv < ActiveSupport::TestCase

    test "Tentando fazer recarga v2 DSTV com usuário NÃO logado" do
        uri = URI("#{Helper.url}/api/v2/recarga/confirma/dstv.json")
        res = HTTParty.post(uri)
        puts "=============[#{res.code}]==============="
        
        assert_equal 401, res.code

        conteudo = res.parsed_response

        puts "=========[#{conteudo}]==============="

        assert_equal conteudo["message"], "Área restrita. Digite o login e palavra-passe para entrar." 
        assert_equal conteudo["code"],  "PGS_SYS_0070"
        assert_equal conteudo["status"],  401
    end

    test "Tentando fazer recarga v2 DSTV com usuário logado" do
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

        debugger
        
        assert_equal 200, res.code


        # conteudo = res.parsed_response

        # assert conteudo["mensagem"].present?
        # assert conteudo["status"] == 401
        # assert conteudo["sucesso"] == false
    end

    
end
