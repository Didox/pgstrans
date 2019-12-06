#!/bin/bash

## Variáveis pra usar abaixo...
agent_id=114250
sequence_id=0
store_id=115356
seller_id=115358
terminal_id=00244TP00221
product_id=450
value=10000
client_msisdn=244916120426
sale_timestamp=`date +%s%3N`

## A chave privada
private_key=/home/pgsadmin/PagasoAPP/pgstrans/chaves/rsapagasoprivkey.pem
public_key=/home/pgsadmin/PagasoAPP/pgstrans/chaves/rsapagasopubkey.der

## Criar a chave privada RSA de 2048 bits
# -> openssl genpkey -algorithm RSA -outform DER -out test_priv_rsa_key.der  -pkeyopt rsa_keygen_bits:2048

## Extrair uma chave pública da chave privada criada anteriormente
# -> openssl rsa -pubout -inform DER -in test_priv_rsa_key.der -outform DER -out test_pub_rsa_key.der

## Parametros da ligação
max_time=30
connect_timeout=30
make_sale_endpoint="https://parceiros.unitel.co.ao:8444/spgw/V2/makeSale"

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
	"saleTimestamp": #SALE_TIMESTAMP#'

## Preparar o pedido makeSale
tmp_make_sale_request=`echo "$make_sale_request" | sed "s/#AGENT_ID#/$agent_id/g" | sed "s/#SEQUENCE_ID#/$sequence_id/g" | sed "s/#STORE_ID#/$store_id/g" | \
sed "s/#SELLER_ID#/$seller_id/g" | sed "s/#TERMINAL_ID#/$terminal_id/g" | sed "s/#PRODUCT_ID#/$product_id/g" | sed "s/#VALUE#/$value/g" | \
sed "s/#CLIENT_MSISDN#/$client_msisdn/g" | sed "s/#SALE_TIMESTAMP#/$sale_timestamp/g"`

#
## Criação do TOKEN para o pedido makeSale
#

# 1 - Concatenar APENAS os dados dos campos por ordem alfabética!
tmp_token_data=$agent_id$client_msisdn$product_id$sale_timestamp$seller_id$sequence_id$store_id$terminal_id$value


# 2 - Encriptar com a chave privada e converter o resultado em Base64
token=`echo "$tmp_token_data" | openssl rsautl -sign -keyform PEM -inkey $private_key | base64`

# 3 - Adicionar o token ao pedido
tmp_make_sale_request="$tmp_make_sale_request"',
	"token": "'$token'"
}'

# Pedido no formato Json
echo "Pedido do makeSale no formato JSON:"
echo "$tmp_make_sale_request"

# Token encryptado
echo -e "\nToken encryptado:"
echo "$token"

echo "=============================================================="
# Desencryptar o token
decrypted_token=`echo "$token" | base64 -d | openssl rsautl -verify -keyform DER -pubin -inkey $public_key`

# Token dencryptado
echo -e "\nToken dencryptado:"
echo "$decrypted_token"

echo "==========================[Enviar no request]===================================="
echo $tmp_make_sale_request
echo "==========================[Enviar no request]===================================="

# Executar o pedido
# echo -n "Parceiro [$agent_id], com vendedor [$seller_id] da loja [$store_id] e terminal [$terminal_id], está a tentar fazer um makeSale do produto [$product_id] de valor [$value] Akz para o msisdn [$client_msisdn]..."
tmp_make_sale_response=`curl -vs -X POST \
	--max-time $max_time --connect-timeout $connect_timeout \
 	$make_sale_endpoint \
 	-H 'Cache-Control: no-cache' \
 	-d "$tmp_make_sale_request"`
