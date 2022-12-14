
class Helper
    def self.url
        ENV["URL_TEST"]
    end

    def self.token_login
        uri = URI("#{Helper.url}/api/login.json")
        res = HTTParty.post(uri, {
            body: {
                "email": "rosi.volgarin@gmail.com",
                "senha": ENV["SENHA_API"]
            }
        }).parsed_response

        return res["token"] rescue ""
    end
end
