module ApplicationHelper
  def usuario_logado
  	Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
  end

  def formata_numero_duas_casas(numero)
    number_to_currency(numero, :precision => 2).downcase.gsub(/kz|\./,"").gsub(",",".")
  end
end
