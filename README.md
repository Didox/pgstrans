# README


::::::::: Backup Database ::::::::: 
pg_dump -h localhost -U "pgsdba" "pgstrans_development" -Fc > dump/pgstrans_development.bkp

::::::::: Backup Database ::::::::: 
pg_restore -U danilo -d pgstrans_development -1 < dump/pgstrans_development.bkp

psql pgstrans_development

CREATE USER pgsdba WITH ENCRYPTED PASSWORD '';


::::::::: Documentações ::::::::: 

url = "https://address/spgw/#{VERSION}/query_string"

uri = URI.parse(URI.escape(url))
request = HTTParty.get(uri, :query => query)
if (200...300).include?(request.code.to_i)
  if request.body.present?
    return JSON.parse(request.body)
  end
end


/home/pgsadmin/.ssh/spgw_public.der ##### arquivo de autnticação MoveCell #####

scp -P22 -r pgsadmin@172.26.8.2:/home/pgsadmin/spgw_public.der ~/Downloads/spgw_public.der
scp -P22 -r ~/Downloads/spgw_public.der pgsadmin@172.26.8.2:/home/pgsadmin/spgw_public.der

## Gerando chave publica para integração
openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout key.pem -out cert.pem
## Convertendo em .der RSA
openssl rsa -in key.pem -pubout -outform DER -out rsapagasopubkey.de