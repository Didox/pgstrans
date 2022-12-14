require 'test_helper'

class RequestMunicipioTest < ActiveSupport::TestCase

    test "Testa se municipio precisa de logina" do
        uri = URI("#{Helper.url}/api/municipios.json")
        res = Net::HTTP.get_response(uri)
        assert res.code == "401"
    end

    test "Tentando municipios logado" do
        uri = URI.parse("#{Helper.url}/api/municipios.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code

        conteudos = response.parsed_response

        assert conteudos.length > 0

        conteudo = conteudos[0]

        assert conteudo["id"].present?
        assert conteudo["nome"].present?
        assert conteudo["provincia_id"].present?

        puts("\nTeste de conteudos com o usuário autenticado: #{conteudo.inspect}]")
    end

    test "Tentando municipios com 10 itens paginado" do
        uri = URI.parse("#{Helper.url}/api/municipios.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code

        conteudos = response.parsed_response

        assert conteudos.length == 10
    end

    test "Tentando municipios com pagina 2" do
        uri = URI.parse("#{Helper.url}/api/municipios.json")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code
        conteudo_pagina_1 = response.parsed_response[0]


        uri = URI.parse("#{Helper.url}/api/municipios.json?page=2")
        response = HTTParty.get(uri, { headers:{ authorization: "Bearer #{Helper.token_login}" } })
        assert_equal 200, response.code
        conteudo_pagina_2 = response.parsed_response[0]

        assert conteudo_pagina_1["id"].present?
        assert conteudo_pagina_2["id"].present?
        assert conteudo_pagina_1["id"] != conteudo_pagina_2["id"]
    end


end