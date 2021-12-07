
dados_cliente = {}
customer_number = 0
Dstv::TRADUCAO_DADOS_CLIENTE.each do |k, v|
  @info[:customer_detail].each do |key, val|
    if key == k
      key_translate = Dstv::TRADUCAO_DADOS_CLIENTE[key].parameterize.gsub("-", "_")
      if val.present? && key_translate.present?
        dados_cliente[key_translate] = val
        customer_number = val if key == "number"
      end
    end
  end
end

dados_conta = {}
@info[:accounts].each do |account|
  Dstv::TRADUCAO_DADOS_CONTAS.each do |k, v|
    account.each do |key, val|
      if key == k
        key_translate = Dstv::TRADUCAO_DADOS_CONTAS[key].parameterize.gsub("-", "_")
        if val.present? && key_translate.present?
          dados_conta[key_translate] = val
        end
      end
    end
  end
end

json.dados_cliente dados_cliente
json.dados_conta dados_conta