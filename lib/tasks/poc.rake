namespace :poc do
  desc "EXECUTA SOAP API TEST"
  task test_soap_api: :environment do
    #respose = RestClient.get("http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/?wsdl")

    client = Savon.client(
      wsdl: 'http://wsqa.movicel.co.ao:10071/DirectTopupService/Topup/?wsdl',
      logger:     Rails.logger,
      log:        true,
      log_level:  :debug,
    )

    puts client.operations

    request_id = "R0869637456"

    timestamp = Time.zone.now

    now_in_angola = Time.use_zone("Africa/Luanda") do
      timestamp = Time.current
    end

    source_system = "Pagaso"
    user = "TivTechno"
    password = "5CF0AC45050B030B9E3A5FC14A5D7C8B609B2BDD40119B5C32539E1F3B6CEF7F"
    name_attr = "Recarga"
    value_attr = "10000"
    amount = "12500"
    msisdn = "244998524570"

    # https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/SHA2.html
    val1 = Digest::SHA2.new(256).hexdigest(password)

    # https://github.com/jtdowney/hkdf
    # hkdf = HKDF.new(password)
    # val2 = hkdf.next_bytes(32)

    # debugger

    password = val1

    puts "==================================="
    puts "RequestId #{request_id}"
    puts "Time now #{timestamp}"
    puts "SourceSystem #{source_system}"
    puts "User #{user}"
    puts "Password #{password}"
    puts "Name Attributes #{name_attr}"
    puts "Value Attributes #{value_attr}"
    puts "Amount #{amount}"
    puts "MSISDN #{msisdn}"

    #debugger

    request = client.call(:validate_topup, 
      message: {
      Header: {
        ValidateTopupReqHeader: {
              RequestId: request_id,
              Timestamp: timestamp,
              SourceSystem: source_system,
              Credentials: {
                User: user,
                Password: password,
              },
              Attributes: {
                  Name: name_attr,
                  Value: value_attr,
              },
            },
        },
        Body: {
          ValidateTopupReq: {
            ValidateTopupReqBody: {
              Amount: amount,
              MSISDN: msisdn,
            }
          }
        }
    })
    
    #debugger

    x = ""

  end

end
