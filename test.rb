require 'byebug'
require 'rest_client'

data = RestClient.get 'https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus', {
  agentId: 83271,
  sequenceId: 12346,
  saleSequenceId: 12343,
  terminalId: "00244TP0000001",
  token: "xtFQYTGlC2SpnVAeXsvKDb1AFeGQPTJNQDxI2lF2R7c9xfln9DeSMV7viDsnjzhsUWUtZMZn/ij5tSKdSqDD1wdCQd0oWz1mEcQ7doNqqKVL8jhjDvOZGmQ/UZmci0IHBr25l581NqYju8YfyLry9zBHj5S+dd96dOejtpp382wNFEMXT+uuVi8Pr22lI7v4XwUvvzwox1K99ddH9O79p48f1XWRNcmF5mKOz/c+QqaONPrxKwTsithneKPqVFuYl7uTo3ERBIcwfO5woi5yir++X7khcS4bdZmH1HUkWPSWzUQ5CEL6Y3c/O/LGh9WBeyBoJis7ZlGxWmpiZe6sXw=="
}

debugger

x = ""