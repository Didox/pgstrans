require 'byebug'
require 'httparty'

query = {
  "agentId": 114250,
  "sequenceId": 0,
  "storeId": 115356,
  "sellerId": 115358,
  "terminalId": "00244TP00221",
  "productId": 450,
  "valueAkz": 10000,
  "clientMsisdn": "244916120426",
  "saleTimestamp": 1575622137758,
  "token": "av/Tbj3t9bkpVS63lv4WnMKzR0Y5Uf92J+WLgxg+CVSJN/7/xiYqqS1dF3TKGbkeCJtRHbGDARkmC7IilpU8lHzERVXkt7+6wk4PKQKEKsvono/DKcTIpe34RBuTfZfviB83ln4L5EVFIGFitjlht0YnvtjqvwDbvpRi92SVz4qydC6sHCjOR6dKJb7EJbLZb5GnUYi0D14meA7ED6/terR211EL45HQ2GIAnpbuFN7D1m+k3HsAEwuPYhzQ7fy4T+smCsmeuQpYhPgS8B5CsT2Tgkl/SQcRQGvZOaFY8R4Sg0t/F+5Mn1a8ndgehirf1cVujvINdOCyFdKp6zla+g=="
}


uri = URI.parse(URI.escape("https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus"))
headers = {"x-noauth" => "true"}
request = HTTParty.get(uri, :query => query, :headers => headers)

puts "======================[request.code]=========================="
puts request.code
puts "================================================"
puts request.body
puts "======================[request.body]=========================="
