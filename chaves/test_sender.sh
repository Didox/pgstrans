#!/bin/bash

make_sale_endpoint="https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale"
tmp_make_sale_request="{ \"agentId\": 114250, \"sequenceId\": 5, \"storeId\": 115356, \"sellerId\": 115709, \"terminalId\": \"00244TP00221\", \"productId\": 9, \"valueAkz\": 500, \"clientMsisdn\": \"943046358\", \"saleTimestamp\": 1575711089776, \"token\": \"l6ruFY67REalPx0XkgzyYtT3BYQwvXnGjN17spl2iKnmOLE8aYyR/akSmHXKkayn6aR4bz180AJ2 Aliec7n9nSYlYaVn+1FGrMRy+wCeaGt4OaIFVl8CxFUFLzgE9VvGj5LzrLGlJh+pDndV7V0b7OF6 POZCZC0QcGisA5rhGq2PcTXMu+7T/cwvF7sR+xccGKeYEBMnd3aytzkrXd+tbS9MBUb2avCTvr5o cBmpF2POu43oTj81gzoJYRufLpFEbpCw/hajxcekLzNazeqPW8wKoCeKgBI4rRf4bJBcBeh1VmUP Bt7B4jBd2FhN4xLdtZ61SEmqFdBCIcXFYwXE4Q==\" }"
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
