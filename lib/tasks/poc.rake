namespace :poc do
  desc "EXECUTA SOAP API TEST"
  task api: :environment do
    res = HTTParty.get(
      "http://10.151.59.196/ao/echarge/pagaso/dev/portfolio/menu", 
      headers: {
        apikey: "b65298a499c84224d442c6a680d14b8e"
      }
    )

    puts res.body

    #debugger

    #DEV – https://10.151.59.196/ao/echarge/pagaso/dev
    #QA - https://10.151.59.196/ao/echarge/pagaso/qa

    

    #/portfolio/menu

    x = ""

  end

end
