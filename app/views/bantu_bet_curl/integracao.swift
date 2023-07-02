
#14/06/2023

#Validação de Dados de Clientes
#Check Client


Exemplos de Transação Válidas


curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=check&account=942766334&paymentID=3128&currency=AOA&sid=1869146&hashcode=a352dd9310faa475eab69f7f4ce40af6'
{"response":{"code":0,"message":"OK","FirstName":"M\u00e1rcio","LastName":"Sanntos"}}%

curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=check&account=946908645&paymentID=3128&currency=AOA&sid=1869146&hashcode=57f6ceec1130226beedb208a78fe32f4'
{"response":{"code":0,"message":"OK","FirstName":"Jonathan","LastName":"Da silva "}}% 



# Depósito

Exemplo de Transação Válida

curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=pay&account=946908645&paymentID=3128&&amount=500&currency=AOA&txn_id=11&sid=1869146&&hashcode=685f0ec94e13cb22623fe4866b538913'
{"response":{"code":0,"message":"OK","FirstName":"","LastName":""}}%

curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=pay&account=946908645&paymentID=3128&amount=500&currency=AOA&txn_id=11&sid=1869146&&hashcode=685f0ec94e13cb22623fe4866b538913'
{"response":{"code":12,"message":"Duplicate transaction number","FirstName":"","LastName":""}}% 

curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=pay&account=946908645&paymentID=3128&amount=500&currency=AOA&txn_id=12&sid=1869146&&hashcode=f3d72b51dc31e5c1024391887ee7bd02'
{"response":{"code":0,"message":"OK","FirstName":"","LastName":""}}%

curl 'https://payments1.betconstruct.com/Bets/PaymentsCallback/TerminalCallbackPG/?command=pay&account=946908645&paymentID=3128&amount=500&currency=AOA&txn_id=13&sid=1869146&hashcode=08bbb634dc77b8eb2f9b31568d7022ca'
{"response":{"code":0,"message":"OK","FirstName":"","LastName":""}}%






