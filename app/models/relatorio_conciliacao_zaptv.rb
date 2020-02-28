class RelatorioConciliacaoZaptv < ApplicationRecord
  belongs_to :partner

  def self.to_csv
    attributes = %w{operation_code source_reference product_code quantity date_time type_data total_price status unit_price zappis}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def zappis
    self.vendas.map { |venda| JSON.parse(venda.request_send)["zappi"] }.join(",")
  rescue 
    ""
  end

  def vendas
    Venda.where(partner_id: self.partner_id).where("response_get ilike '%\"operation_code\": #{self.operation_code}%' ")
  end
end
