#!/bin/bash

connect_timeout=30
max_time=30
make_sale_endpoint="https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale"
tmp_make_sale_request="{ \"agentId\": 114250, \"sequenceId\": 6, \"storeId\": 115356, \"sellerId\": 115709, \"terminalId\": \"00244TP00221\", \"productId\": 9, \"valueAkz\": 500, \"clientMsisdn\": \"943046358\", \"saleTimestamp\": 1575711646790, \"token\": \"yhoS9fOw+7/cPbHuNzyEQx3v3q/lRsYxWK9ek6fzLYimkt+GdqerdPkzDBzN7edg7HD8v8U7WKm3 fEi0bdzZdFBMYRl40O0es4QCHBKr06rWs27wOvl7BXxbqU0HyDfGSdFWCvyRqbThsuebOnfNWf2z FO5eOBQ1VZAvDFB7aVNVgIVxU/skpvH2iZQfIVnL2MSRc2Q6KaAuRe/U2QxX1mEfQt1eCNQ/cF0e cVRB3g7UzdIXOp0UPFzzTFCoQmNa0WjQO5inwmr4Fb66TOLvezgvKFDjGgFjKVJGGUDZjZRFGkO5 u04TlF5VD0Koz2cW0olbfT0Mkicy5TCl6leodw==\" }"
echo "==========================[Enviar no request]===================================="
echo $tmp_make_sale_request
echo "==========================[Enviar no request]===================================="

## Executar o pedido
### echo -n "Parceiro [$agent_id], com vendedor [$seller_id] da loja [$store_id] e terminal [$terminal_id], está a tentar fazer um makeSale do produto [$product_id] de valor [$value] Akz para o msisdn [$client_msisdn]..."
tmp_make_sale_response=`curl -vs -X POST \
	--max-time $max_time --connect-timeout $connect_timeout \
 	$make_sale_endpoint \
 	-H 'Cache-Control: no-cache' \
 	-d "$tmp_make_sale_request"`

echo "==========================[Enviar no request]===================================="
echo $tmp_make_sale_response
echo "==========================[Enviar no request]===================================="