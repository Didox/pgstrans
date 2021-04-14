# README


  ### adicionar no modelo
  include PermissionamentoDados

  ### adicionar no controller na acao index trocar a palavra .all ou se tiver classe como NomeDoModel.where NomeDoModel.com_acesso(usuario_logado).where 
  com_acesso(usuario_logado)

  # incluir no create depois de criar a instancia
  # incluir no set_[model] depois de criar a instancia
  @usuario.responsavel = usuario_logado


::::::::: Backup Database ::::::::: 
pg_dump -h localhost -U "pgsdba" "pgstrans_development" -Fc > dump/pgstrans_development.bkp
pg_dump -h localhost -U "pgsdba" "pgstrans_production" -Fc > dump/pgstrans_production.bkp

::::::::: Backup Database ::::::::: 
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 rake db:drop
rake db:create
pg_restore -U danilo -d pgstrans_development -1 < dump/pgstrans_production.bkp

psql pgstrans_development

CREATE USER pgsdba WITH ENCRYPTED PASSWORD '';

Etapas para o restore
rails db:drop
rails db:create
pg_restore --host localhost --port 5432 --username pgsdba --dbname pgstrans_development < dump/pgstrans_production_1012_0431.bkp
Password: senha do banco de dados da aplicação




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

RelatorioConciliacaoZaptv.create(
  partner_id: 4,
  url: "http://10.151.59.196/ao/echarge/pagaso/dev/carregamento/report/2020-02-15",
  operation_code: "5144570",
  source_reference: "15022020101420",
  product_code: 441,
  quantity: 1,
  date_time: DateTime.parse("2020-02-15 09:14:24"),
  type_data: "carregamento",
  total_price: 3750.0,
  status: "processado",
  unit_price: 3440.0,
)


#<style>
#.desk{
#    width: 100%
#}
#@media only screen and (max-width: 600px) {
#    .desk{
#        width: 100%
#    }
#}
#</style>












-----------------------------------------------------------------------------



venda = Venda.find(129)
parceiro = Partner.where("lower(slug) = 'zaptv'").first
parametro = Parametro.where(partner_id: parceiro.id).first

if Rails.env == "development"
  url = "#{parametro.url_integracao_desenvolvimento}/carregamento/#{venda.request_id}"
  api_key = parametro.api_key_zaptv_desenvolvimento
else
  url = "#{parametro.url_integracao_producao}/carregamento/#{venda.request_id}"
  api_key = parametro.api_key_zaptv_producao
end

res = HTTParty.get(
  url, 
  headers: {
    "apikey" => api_key,
    "Content-Type" => "application/json"
  }
)

res.body







--------------------------------------------------------


part = Partner.where(slug: "ZAPTv").first

parametro = Parametro.where(partner_id: part.id).first
if Rails.env == "development"
  host = "#{parametro.url_integracao_desenvolvimento}/portfolio"
  api_key = parametro.api_key_zaptv_desenvolvimento
else
  host = "#{parametro.url_integracao_producao}/portfolio"
  api_key = parametro.api_key_zaptv_producao
end

data = Time.zone.now - 1.days
url = "#{host}/carregamento/report/#{data.strftime("%Y-%m-%d")}"
data = data + 1.day


res = HTTParty.get(
  url, 
  headers: {
    "apikey" => api_key,
    "Content-Type" => "application/json"
  }
)

--------------------------------------------------------


venda = Venda.find(129)

parceiro = Partner.where("lower(slug) = 'zaptv'").first
parametro = Parametro.where(partner_id: parceiro.id).first

if Rails.env == "development"
  url = "#{parametro.url_integracao_desenvolvimento}/carregamento/#{venda.request_id}"
  api_key = parametro.api_key_zaptv_desenvolvimento
else
  url = "#{parametro.url_integracao_producao}/carregamento/#{venda.request_id}"
  api_key = parametro.api_key_zaptv_producao
end

res = HTTParty.delete(
  url, 
  headers: {
    "apikey" => api_key,
    "Content-Type" => "application/json"
  }
)

if (200..300).include?(res.code)
  venda.status = "7000"
  venda.save!
  return "sucesso"
else
  return "Delete in (#{url}) - #{res.body}"
end

res.body

