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