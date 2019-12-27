namespace :soap_movicel do
  desc "Movicel SOAP API GET"
  task movicel_topup: :environment do
    require 'openssl'

    agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    user_id = "TivTechno"
    msisdn = "244998524570"
    request_id = Time.now.strftime("%d%m%Y%H%M%S")
    valor = 100

    #### MAC ####
    #pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/encripto`
    #### Ubuntu ####
    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`

    pass = pass.strip

    body = "
      <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
        <soapenv:Header>
            <int:TopupReqHeader>
               <mid:RequestId>#{request_id}</mid:RequestId>
               <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
               <!--Optional:-->
               <mid:SourceSystem>TivTechno</mid:SourceSystem>
               <mid:Credentials>
                  <mid:User>#{user_id}</mid:User>
                  <mid:Password>#{pass}</mid:Password>
               </mid:Credentials>
               <!--Optional:-->        
            </int:TopupReqHeader>
        </soapenv:Header>
        <soapenv:Body>
            <int:TopupReq>
               <!--Optional:-->
               <int:TopupReqBody>
                  <mid1:Amount>#{valor}</mid1:Amount>
                  <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
                  <!--Optional:-->
                  <mid1:Type>Default</mid1:Type>
               </int:TopupReqBody>
            </int:TopupReq>
        </soapenv:Body>
      </soapenv:Envelope>
    "


    url = "http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup',
        # 'Accept-Encoding' => 'gzip,deflate',
        # 'Content-Length' => '1224',
        # 'Host' => 'wsqa.movicel.co.ao:10071',
        # 'Connection' => 'Keep-Alive',
        # 'User-Agent' => 'Apache-HttpClient/4.1.1 (java 1.5)',
      },
      :body => body)
    
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        puts "=========================================="
        puts request.body
        puts "=========================================="
      end
    end
  end

  desc "EXECUTA SOAP API TEST"
  task movicel_validate_topup: :environment do

    agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    user_id = "TivTechno"
    msisdn = "244998524570"
    request_id = Time.now.strftime("%d%m%Y%H%M%S")
    valor = 100

    #### MAC ####
    pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/mac/encripto`
    #### Ubuntu ####
    # pass = `AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto`

    pass = pass.strip


    url = "http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/"
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, 
      :headers => {
        'Content-Type' => 'text/xml;charset=UTF-8',
        'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup',
      },
      :body => "
        <soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
          <soapenv:Header>
           <int:ValidateTopupReqHeader>
              <mid:RequestId>#{request_id}</mid:RequestId>
              <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
              <mid:SourceSystem>#{user_id}</mid:SourceSystem>  
              <mid:Credentials>
                 <mid:User>#{user_id}</mid:User>
                 <mid:Password>#{pass}</mid:Password>
                 </mid:Credentials>
                 <!--Optional:--> 
              </int:ValidateTopupReqHeader>
          </soapenv:Header>
          <soapenv:Body>
              <int:ValidateTopupReq>
                 <!--Optional:-->
                 <int:ValidateTopupReqBody>
                    <mid1:Amount>100</mid1:Amount>
                    <mid1:MSISDN>#{msisdn}</mid1:MSISDN>
                 </int:ValidateTopupReqBody>
              </int:ValidateTopupReq>
          </soapenv:Body>
        </soapenv:Envelope>
      "
    )

    if (200...300).include?(request.code.to_i)
      if request.body.present?
        puts "=========================================="
        puts request.body
        puts "=========================================="
      end
    end
  end

end
