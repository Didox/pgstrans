VERSION="v2"
URL_SITE=ENV["URL_SITE"] || "https://recarga.pagaso.co.ao/"
DEFAULT_TIMEOUT = ENV["DEFAULT_TIMEOUT"] || 60
AWS_ID=ENV["AWS_ID"]
AWS_KEY=ENV["AWS_KEY"]
AWS_BUCKET=ENV["AWS_BUCKET"]
SECRET_JWT = '!p@a##g$a%s%o^ro&s*i(())'
AMBIENTE_QA=ENV["AMBIENTE_QA"]

String.class_eval do
  def to_f_ptBR
    return self.to_f unless self.include?(",")
    self.gsub(".", "").gsub("R$", "").gsub(",", ".").to_f
  end

  def remove_injection
    return self.to_s.gsub("'", "")
  end
end