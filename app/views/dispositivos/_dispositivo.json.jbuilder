json.extract! dispositivo, :id, :nome, :marca, :modelo, :numero_serie, :macaddr, :imei, :created_at, :updated_at
json.url dispositivo_url(dispositivo, format: :json)
