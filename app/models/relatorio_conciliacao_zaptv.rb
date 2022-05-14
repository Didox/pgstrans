class RelatorioConciliacaoZaptv < ApplicationRecord
  belongs_to :partner

  def self.to_csv
    #attributes = %w{operation_code source_reference product_code product_name quantity date_time type_data total_price status unit_price card_number}
    attributes = %w{product_code product_name unit_price total_price date_time source_reference operation_code card_number status}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      debugger



      sql = '
        select 
          (
            select vendas.zappi from Vendas 
            where partner_id = relatorio_conciliacao_zaptvs.partner_id
            and response_get ilike concat('%:', relatorio_conciliacao_zaptvs.operation_code, '%')
            or response_get ilike concat('%: ', relatorio_conciliacao_zaptvs.operation_code, '%')
            limit 1
          ) as product_name,
          (
            select produtos.description
            from produtos
            where CAST(coalesce(produtos.produto_id_parceiro, '0') AS integer) = relatorio_conciliacao_zaptvs.product_code and produtos.partner_id = relatorio_conciliacao_zaptvs.partner_id
            limit 1
          ) as card_number,
          relatorio_conciliacao_zaptvs.product_code,
          relatorio_conciliacao_zaptvs.unit_price,
          relatorio_conciliacao_zaptvs.total_price,
          relatorio_conciliacao_zaptvs.date_time,
          relatorio_conciliacao_zaptvs.source_reference,
          relatorio_conciliacao_zaptvs.operation_code,
          relatorio_conciliacao_zaptvs.status
        FROM "relatorio_conciliacao_zaptvs"  
        WHERE "relatorio_conciliacao_zaptvs"."partner_id" = 4 ORDER BY date_time desc LIMIT 10
      '

      # TODO usar o activerecord para buscar os dados.
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def product_name
    Produto.produtos.where(produto_id_parceiro: self.product_code, partner_id: self.partner_id).map{|p| p.description}.join(" ")
  end

  def card_number
    self.vendas.map { |venda| venda.zappi }.join(" ")
  rescue 
    ""
  end

  def vendas
    Venda.where(partner_id: self.partner_id).where("response_get ilike '%:#{self.operation_code},%' or response_get ilike '%: #{self.operation_code},%' ")
  end
end
