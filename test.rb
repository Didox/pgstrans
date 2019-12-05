require 'byebug'
require 'rest-client'

data = RestClient.get 'https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus', {
  agentId: 114250,
  storeId: 115356,
  sellerId: 115709,
  sequenceId: 12346,
  saleSequenceId: 12343,
  terminalId: "00244TP00221",
  token: "Y7fEbaU1os7yvwGPuIKTePxIzID0uS06vDd2UL+oGwPkqJT6Na23LXREW6U6VaK8L6Fl7GRWunMqkV2/SGxNAwF9AqecOUeNxp2f/AimDvCqmYV/axcEgKh2lrGlpnUBd1JHoT2tg7m31mqae/5MpphzQFUrJ21NXHGYGlNj0aw="
}

debugger

x = ""