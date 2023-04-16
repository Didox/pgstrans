
19/03/2023

Authentication
# Metodo GET

## Desenvolvimento


curl "https://developer.proxypay.co.ao/v2/" \
  -H 'Authorization: Token omj8nk3oh7pvt6k5p9irq2ne4a34pl5i' \
  -H 'Accept: application/vnd.proxypay.v2+json' \
  -H 'Content-Type: application/json'


 https://api.sandbox.proxypay.co.ao/references/938849107

## Registrar uma referencia

curl -X PUT "https://api.sandbox.proxypay.co.ao////references/938849108" \
  -H "Authorization: Token omj8nk3oh7pvt6k5p9irq2ne4a34pl5i" \
  -H 'Accept: application/vnd.proxypay.v2+json'


## https://app.sandbox.proxypay.co.ao/references


## Apagar uma referencia

  curl -X DELETE "https://api.sandbox.proxypay.co.ao/references/938849108" \
  -H "Authorization: Token omj8nk3oh7pvt6k5p9irq2ne4a34pl5i" \
  -H 'Accept: application/vnd.proxypay.v2+json'





curl -H "Content-Type: application/json" -I -X POST http://localhost:3000/webhook/conciliacao_proxy_pay.json

curl -H "Content-Type: application/json" -I -X POST https://aoa.qa.recarga.pagaso.co.ao:3001/webhook/conciliacao_proxy_pay.json


curl -d '{
  "transaction_id": 26356,
  "terminal_type": "IB",
  "terminal_transaction_id": 0,
  "terminal_location": null,
  "terminal_id": "4644327306",
  "reference_id": 111111139,
  "product_id": null,
  "period_start_datetime": "2007-03-13T19:00:00Z",
  "period_id": 1562,
  "period_end_datetime": "2007-03-14T19:00:00Z",
  "parameter_id": 0,
  "id": 156200026356,
  "fee": "50.00",
  "entity_id": 411,
  "datetime": "2017-01-17T09:08:00Z",
  "custom_fields": {},
  "amount": "1000.01"
}' -H "Content-Type: application/json" -H "X-Signature: b2faea0b081025ab55881e7684615c3920d2c67b4694c6ff770b5225c9fd464c" -X POST http://localhost:3000/webhook/conciliacao_proxy_pay.json


170813645

curl -d '{
  "transaction_id": 26356,
  "terminal_type": "IB",
  "terminal_transaction_id": 0,
  "terminal_location": null,
  "terminal_id": "4644327306",
  "reference_id": 170813645,
  "product_id": null,
  "period_start_datetime": "2023-03-30T19:00:00Z",
  "period_id": 1562,
  "period_end_datetime": "2023-03-30T19:00:00Z",
  "parameter_id": 0,
  "id": 156200026356,
  "fee": "50.00",
  "entity_id": 411,
  "datetime": "2023-03-30T09:08:00Z",
  "custom_fields": {},
  "amount": "1000.01"
}' -H "Content-Type: application/json" -H "X-Signature: b2faea0b081025ab55881e7684615c3920d2c67b4694c6ff770b5225c9fd464c" -X POST http://localhost:3000/webhook/conciliacao_proxy_pay.json


curl -d '{
  "transaction_id": 26356,
  "terminal_type": "IB",
  "terminal_transaction_id": 0,
  "terminal_location": null,
  "terminal_id": "4644327306",
  "reference_id": 170813645,
  "product_id": null,
  "period_start_datetime": "2023-04-08T19:00:00Z",
  "period_id": 1562,
  "period_end_datetime": "2023-04-18T19:00:00Z",
  "parameter_id": 0,
  "id": 156200026356,
  "fee": "50.00",
  "entity_id": 411,
  "datetime": "2023-04-08T09:08:00Z",
  "custom_fields": {},
  "amount": "1000.02"
}' -H "Content-Type: application/json" -H "X-Signature: b2faea0b081025ab55881e7684615c3920d2c67b4694c6ff770b5225c9fd464c" -X POST https://aoa.qa.recarga.pagaso.co.ao:3001/webhook/conciliacao_proxy_pay.json



CURL qa

Formato correto do CURL para QA

 curl -d '{
  "transaction_id": 26356,
  "terminal_type": "IB",
  "terminal_transaction_id": 0,
  "terminal_location": null,
  "terminal_id": "4644327306",
  "reference_id": 894578794,
  "product_id": null,
  "period_start_datetime": "2023-04-08T19:00:00Z",
  "period_id": 1562,
  "period_end_datetime": "2023-04-18T19:00:00Z",
  "parameter_id": 0,
  "id": 156200026356,
  "fee": "50.00",
  "entity_id": 411,
  "datetime": "2023-04-08T09:08:00Z",
  "custom_fields": {},
  "amount": "1000.02"
}' -H "Content-Type: application/json" -H "X-Signature: b2faea0b081025ab55881e7684615c3920d2c67b4694c6ff770b5225c9fd464c" -X POST https://aoa.qa.recarga.pagaso.co.ao/webhook/conciliacao_proxy_pay.json

