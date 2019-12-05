require 'byebug'
require 'rest-client'

data = RestClient.get 'https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus', {
  agentId: 114250,
  storeId: 115356,
  sellerId: 115709,
  sequenceId: 12346,
  saleSequenceId: 12343,
  terminalId: "00244TP00221",
  token: "C2RHhXiwWnHbheaTcd4Sfoemj5ToEPVJbIZOrDGPAhIeLxAJ/PMRQNtZhgfEo/t2v/aLm/RZK+qezh/YgrU3lMuoCUoUGh6/v6JJ9iFXI8e6Q+PxCmpmY2lJtRLgQFU2yqkzS7Ia0FgiE11NWo/bYLqVXTq4J1jq1s7p1ueItoQ="
}

debugger

x = ""