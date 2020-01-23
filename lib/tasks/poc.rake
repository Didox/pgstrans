namespace :poc do
  desc "EXECUTA SOAP API TEST"
  task api: :environment do
    res = HTTParty.post(
      "http://10.151.59.196/ao/echarge/pagaso/dev/carregamento", 
      headers: {
        apikey: "b65298a499c84224d442c6a680d14b8e"
      },
      :body => {
        :price => 995.0, 
        :product_code => 461, #produto importado zap
        :product_quantity => 1, 
        :source_reference => "1234", #meu código 
        :zappi => '109105077292' #Iremos receber este numero
      }.to_json,
    )

    puts res.body

    debugger

    #DEV – https://10.151.59.196/ao/echarge/pagaso/dev
    #QA - https://10.151.59.196/ao/echarge/pagaso/qa

    

    #/portfolio/menu

    x = ""

  end
end