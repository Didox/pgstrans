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
customer_number=$8
make_sale_endpoint=$9
sale_timestamp=`date +%s%3N`


## A chave privada
private_key=/home/pgsadmin/PagasoAPP/pgstrans/chaves/unitel/producao/producao_rsapagasoprivkey.pem
public_key=/home/pgsadmin/PagasoAPP/pgstrans/chaves/unitel/producao/producao_rsapagasopubkey.der

## Criar a chave privada RSA de 2048 bits
# -> 
#How to
#https://stefanauwyang.com/convert-openssl-private-and-public-key-to-der/
#https://rietta.com/blog/openssl-generating-rsa-key-from-command/
#generate .pem
#private
#$     openssl genrsa -out private.pem 2048
#public
#$     openssl rsa -in private.pem -outform PEM -pubout -out public.pem
#generate .der
#private
#$     openssl pkcs8 -topk8 -inform PEM -outform DER -in private.pem -out private.der -nocrypt
#public
#$     openssl rsa -in private.pem -pubout -outform DER -out public.der

## Parametros da ligação
max_time=30
connect_timeout=30
# make_sale_endpoint="https://parceiros.unitel.co.ao:8444/spgw/V2/getStatus"

## Exemplo simples, de como criar um pedido de makeSale à API de parceiros
make_sale_request='
{
	"agentId": #AGENT_ID#,
	"sequenceId": #SEQUENCE_ID#,
	"storeId": #STORE_ID#,
	"sellerId": #SELLER_ID#,
	"terminalId": "#TERMINAL_ID#",
	"productId": #PRODUCT_ID#,
	"valueAkz": #VALUE#,
	"clientMsisdn": "#CLIENT_MSISDN#",
	"saleTimestamp": "#SALE_TIMESTAMP#"'

## Preparar o pedido makeSale
tmp_make_sale_request=`echo "$make_sale_request" | sed "s/#AGENT_ID#/$agent_id/g" | sed "s/#SEQUENCE_ID#/$sequence_id/g" | sed "s/#STORE_ID#/$store_id/g" | \
sed "s/#SELLER_ID#/$seller_id/g" | sed "s/#TERMINAL_ID#/$terminal_id/g" | sed "s/#PRODUCT_ID#/$product_id/g" | sed "s/#VALUE#/$value/g" | \
sed "s/#CLIENT_MSISDN#/$customer_number/g" | sed "s/#SALE_TIMESTAMP#/$sale_timestamp/g"`

#
## Criação do TOKEN para o pedido makeSale
#

# 1 - Concatenar APENAS os dados dos campos por ordem alfabética!
tmp_token_data=$agent_id$customer_number$product_id$sale_timestamp$seller_id$sequence_id$store_id$terminal_id$value


# 2 - Encriptar com a chave privada e converter o resultado em Base64
token=`echo "$tmp_token_data" | openssl rsautl -sign -keyform PEM -inkey $private_key | base64`

# 3 - Adicionar o token ao pedido
tmp_make_sale_request="$tmp_make_sale_request"',
	"token": "'$token'"
}'

##### Executar o pedido
##### echo -n "Parceiro [$agent_id], com vendedor [$seller_id] da loja [$store_id] e terminal [$terminal_id], está a tentar fazer um makeSale do produto [$product_id] de valor [$value] Akz para o msisdn [$customer_number]..."
tmp_make_sale_response=`curl -vs -X POST \
	--max-time $max_time --connect-timeout $connect_timeout \
 	$make_sale_endpoint \
 	-H 'Cache-Control: no-cache' \
 	-d "$tmp_make_sale_request"`

echo "$tmp_make_sale_request --- $tmp_make_sale_response"



