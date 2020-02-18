class RelatorioConciliacaoZaptv < ApplicationRecord
  belongs_to :partner

  def self.to_csv
    attributes = %w{operation_code source_reference product_code quantity date_time type_data total_price status unit_price}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
