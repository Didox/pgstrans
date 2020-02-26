#!/bin/bash

## Variáveis pra usar abaixo...
## alterar a sequencia a cada nova requisicao
## o próximo pedido que fizerem ( quer seja makeSale, quer seja getStatus ) a sequence tem de ser encrementada!
## ultima sequencia enviada 3
##

sequence_id=$1
product_id=$2
agent_id=$3
store_id=$4
seller_id=$5
terminal_id=$6
value=$7
client_msisdn=$8
make_sale_endpoint=$9
sale_timestamp=`date +%s%3N`

echo "============== $terminal_id =============="



