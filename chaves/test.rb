require 'byebug'
require 'httparty'

file = "sequence.txt"

sequence_id = File.read(file).to_i rescue 1
product_id = 9 ### http://localhost:3000/produtos/5 - campo código que será enviado
agent_id = 114250 ### ID FIXO do sistema
store_id = 115356 ### http://localhost:3000/matrix_users/3 - campo PDV = 1
seller_id = 115709 ### http://localhost:3000/sub_agentes/1
terminal_id = "00244TP00221" ### http://localhost:3000/matrix_users/3 - campo terminal_id que será criado
value = 500 ### http://localhost:3000/ - escolhido ao selecionar campo de recarga na home 
client_msisdn = 943046358 ### http://localhost:3000/ - telefone digitado na entrada de dados home

retorno = `./exec.sh #{sequence_id} #{product_id} #{agent_id} #{store_id} #{seller_id} #{terminal_id} #{value} #{client_msisdn}`

File.write(file, (sequence_id + 1))

puts "======================[retorno]=========================="
puts retorno_hash = JSON.parse(retorno)

debugger

x = ""