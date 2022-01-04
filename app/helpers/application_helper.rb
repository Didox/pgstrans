module ApplicationHelper
  def usuario_logado
  	Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
  end

  def formata_numero_duas_casas(numero)
    number_to_currency(numero.to_f, :precision => 2).downcase.gsub(/kz|\./,"").gsub(",",".")
  end

  def akz_parse(symbol)
    return symbol.to_s.upcase.strip == "AOA" ? "AKz" : symbol
  end
end
