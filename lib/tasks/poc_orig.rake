namespace :poc do
  desc "EXECUTA SOAP API TEST"
  task test_soap_api: :environment do
  	#respose = RestClient.get("http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/?wsdl")

  	client = Savon.client(wsdl: "http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/?wsdl")

  	puts client.operations

  	r = client.call(:validate_topup, 
  		message: {
  			Header:{
  				ValidateTopupReqHeader: {
  					RequestId: "244992576873",
  					Timestamp: "2019-11-02T09:46:50",
  					SourceSystem: "Teste",
  					Credentials: {
			  			User: "TivTechno",
			  			Password: "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F",
			  		},

  				}
  			},
  			Body:{
  				ValidateTopupReq:{
					ValidateTopupReqBody:{
						Amount: "12500",
						MSISDN: "244992576873"
					}
				}
  			}
	  	}
  	)

  	#debugger

  	x = ""

  end

end
