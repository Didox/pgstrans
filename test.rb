require 'byebug'
require 'rest-client'

data = RestClient.get 'https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus', {
  agentId: 114250,
  storeId: 115356,
  sellerId: 115709,
  sequenceId: 12346,
  saleSequenceId: 12343,
  terminalId: "00244TP00221",
  token: "ew0KwqAgImNsaWVudE1zaXNkbiI6ICIrMjQ0OTg3NjU0MzIxIiwNCsKgICJwcm9kdWN0SWQiOiAxMywNCsKgICJzYWxlVGltZXN0YW1wIjogMTQ3OTY2NzMyMA0KwqAgInNlcXVlbmNlSWQiOiAxMjM0NSwNCsKgICJzZWxsZXJJZCI6IDgzMjcxLA0KwqAgInN0b3JlSWQiOiA4MzI3MSwNCsKgICJ0ZXJtaW5hbElkIjogIisyNDQxMjM0NTY3ODkiLA0KwqAgInZhbHVlQWt6IjogMTAwMCwNCn0="
}

debugger

x = ""