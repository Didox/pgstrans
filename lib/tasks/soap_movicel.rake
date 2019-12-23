namespace :soap_movicel do
  desc "Movicel SOAP API GET"
  task movicel_topup: :environment do

    # private void button1_Click(object sender, EventArgs e)
    # {
    #     string message = string.Empty;
    #     string text = this.txtAgentKey.Text;
    #     message = !this.RdRU.Checked ? (!this.rdRUM.Checked ? (this.txtReqId.Text + this.txtUid.Text) : (this.txtReqId.Text + this.txtUid.Text + this.txtMSISDn.Text)) : (this.txtReqId.Text + this.txtUid.Text);
    #     string str3 = Encryption.HashHMACHex(text, message);
    #     this.txtFinalKey.Text = str3;
    # }

    # public static string HashHMACHex(string keyHex, string message) => 
    # HashEncode(HashHMAC(HexDecode(keyHex), StringEncode(message)));

    # private void button2_Click(object sender, EventArgs e)
    # {
    #     this.txtReqId.Text = DateTime.Now.ToString("ddMMyyyyhhmmss");
    # }



    require 'openssl'

    agent_key = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    user_id = "TivTechno"
    msisdn = "244998524570"
    # request_id = Time.now.strftime("%d%m%Y%H%M%S")
    request_id = Time.parse("21/12/2019 07:45:12").strftime("%d%m%Y%H%M%S")
    valor = 100

    # message = "#{request_id}#{user_id}#{msisdn}" # Like Ravindra code not checked
    # message = "#{request_id}#{user_id}" # like Ravindra C# code
    # message = "#{request_id}#{msisdn}" # Like documentation invertido - Ravindra
    message = "#{msisdn}#{request_id}" # Like documentation

    # digest = OpenSSL::Digest::SHA.new
    # digest = OpenSSL::Digest::SHA1.new
    # digest = OpenSSL::Digest::SHA224.new
    digest = OpenSSL::Digest::SHA256.new
    # digest = OpenSSL::Digest::SHA384.new
    # digest = OpenSSL::Digest::SHA512.new
    pass = OpenSSL::HMAC.hexdigest(digest, message, agent_key)
    # pass = OpenSSL::HMAC.hexdigest(digest, agent_key, message)

    puts "=============================="
    puts pass
    puts "=============================="
    puts "2842d851799b2d0374d5f55d66428b67ba35b651e02b1936663a3b2f58f05a87"
    puts "=============================="

    # pass = "2842d851799b2d0374d5f55d66428b67ba35b651e02b1936663a3b2f58f05a87"


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
      :body => "
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
    )

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
              <mid:RequestId>#{Time.zone.now.to_i}</mid:RequestId>
              <mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
              <mid:SourceSystem>TivTechno</mid:SourceSystem>  
              <mid:Credentials>
                 <mid:User>TivTechno</mid:User>
                 <mid:Password>2f168e37b1dc8936605ba308d51098530569d8dc4048e1e21d8770a3abe04993</mid:Password>
                 </mid:Credentials>
                 <!--Optional:--> 
              </int:ValidateTopupReqHeader>
          </soapenv:Header>
          <soapenv:Body>
              <int:ValidateTopupReq>
                 <!--Optional:-->
                 <int:ValidateTopupReqBody>
                    <mid1:Amount>100</mid1:Amount>
                    <mid1:MSISDN>244998524570</mid1:MSISDN>
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
