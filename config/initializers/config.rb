VERSION="v2"
URL_SITE=ENV["URL_SITE"] || "https://recarga.pagaso.co.ao/"
DEFAULT_TIMEOUT = ENV["DEFAULT_TIMEOUT"] || 60
AWS_ID=ENV["AWS_ID"]
AWS_KEY=ENV["AWS_KEY"]
AWS_BUCKET=ENV["AWS_BUCKET"]
SECRET_JWT = '!p@a##g$a%s%o^ro&s*i(())'
AMBIENTE_QA=ENV["AMBIENTE_QA"]
URL_SMS=ENV["URL_SMS"] || "https://api.wesender.co.ao/envio/apikey"
API_KEY_SMS=ENV["API_KEY_SMS"] || '83be516184bf47e29c123b9c37b5c3638822e12e0078425cb35ef6a68908aa15'
SQS_URL=ENV["SQS_URL"] || "https://sqs.us-east-1.amazonaws.com/621964606260/RelatoriosCSVPagaso"

GOOGLE_CLIENT_ID=ENV["GOOGLE_CLIENT_ID"] || "78799946860-j3cbcbraeqp1227gnff4b7g00tbaahpa.apps.googleusercontent.com"
GOOGLE_SECRET=ENV["GOOGLE_SECRET"] || "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"
GOOGLE_URL_RETORNO=ENV["GOOGLE_URL_RETORNO"] || "http://localhost:3000/africell/auth"

String.class_eval do
  def to_f_ptBR
    return self.to_f unless self.include?(",")
    self.gsub(".", "").gsub("R$", "").gsub(",", ".").to_f
  end

  def remove_injection
    return self.to_s.gsub("'", "")
  end
end