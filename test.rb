require 'byebug'
require 'httparty'

query = { "agentId": 114250, "sequenceId": 0, "storeId": 115356, "sellerId": 115358, "terminalId": "00244TP00221", "productId": 450, "valueAkz": 10000, "clientMsisdn": "244916120426", "saleTimestamp": 1575622855179, "token": "SZb12iswmEiEKcdAEzK3HYcU/ibhCCPgcSnXsn0CBx3qiq/z4Lg1ikXSmWqbC9T2ahNjSprwco/o oDecVQSwrpSoTgjTtBlTvuKJlbs7Rwxr5XG9pxVPkSICZjadSV9U5opPFdWhtU/PYg5LZOpmDDTu NMRfAtIi+OUKHwnvJ0aQwMp+9K0i8A/qEA+0y8eyDJQ/mELFItK3gX0QKbgDI85v7NouppcFdQ7m abNyOmsLP4Y08XIkAm7RLp/MTsL8VPad1d1RkUjyWojRbMx0cuNuw7MXaZKbcMezDAAvZ7iuTc91 FMqtgyrvOiq+GK7+bq1N7lBkT1/FMfU+dUYC5w==" }

uri = URI.parse(URI.escape("https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale"))
headers = {"x-noauth" => "true"}
request = HTTParty.post(uri, :query => query, :headers => headers)

puts "======================[request.code]=========================="
puts request.code
puts "================================================"
puts request.body
puts "======================[request.body]=========================="
