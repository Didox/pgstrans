require 'byebug'
require 'httparty'

file = "sequence.txt"
sequence_id = File.read(file).to_i rescue 1
product_id = 9

retorno = `./exec.sh #{sequence_id} #{product_id}`

File.write(file, (sequence_id + 1))

puts "======================[retorno]=========================="
puts retorno_hash = JSON.parse(retorno)

debugger

x = ""