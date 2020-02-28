class RelatorioConciliacaoZaptv < ApplicationRecord
  belongs_to :partner

  def self.to_csv
    attributes = %w{operation_code source_reference product_code product_name quantity date_time type_data total_price status unit_price numero_cartao}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def product_name
    Produto.where(produto_id_parceiro: self.product_code, partner_id: self.partner_id).map{|p| p.description}.join(" ")
  end

  def numero_cartao
    self.vendas.map { |venda| JSON.parse(venda.request_send)["zappi"] }.join(" ")
  rescue 
    ""
  end

  def vendas
    Venda.where(partner_id: self.partner_id).where("response_get ilike '%\"operation_code\": #{self.operation_code}%' ")
  end
end
