require 'byebug'
require 'httparty'

product_id = 9
sequence_id = File.open("sequence.txt").readlines.to_i

retorno = `./exec.sh #{sequence_id} #{product_id}`

File.write("sequence.txt", (sequence_id + 1))

puts "======================[retorno]=========================="
puts retorno
puts "================================================"
puts retorno
puts "======================[retorno]=========================="
