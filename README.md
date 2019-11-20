# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


::::::::: Documentações ::::::::: 

url = "https://address/spgw/#{VERSION}/query_string"

uri = URI.parse(URI.escape(url))
request = HTTParty.get(uri, :query => query)
if (200...300).include?(request.code.to_i)
  if request.body.present?
    return JSON.parse(request.body)
  end
end