namespace :poc do
  desc "EXECUTA SOAP API TEST"
  task api: :environment do
    res = HTTParty.post(
      "http://10.151.59.196/ao/echarge/pagaso/dev/carregamento", 
      headers: {
        "apikey" => "b65298a499c84224d442c6a680d14b8e",
        "Content-Type" => "application/json"
      },
      :body => {
        :price => 995.0, 
        # :price => 3595, 
        :product_code => 461, #produto importado zap
        :product_quantity => 1, 
        :source_reference => "12345", #meu código 
        :zappi => '109105077292' #Iremos receber este numero
      }.to_json,
    )

    puts res.body

    #DEV – https://10.151.59.196/ao/echarge/pagaso/dev
    #QA - https://10.151.59.196/ao/echarge/pagaso/qa

    

    #/portfolio/menu

    x = ""

  end
end