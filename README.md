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