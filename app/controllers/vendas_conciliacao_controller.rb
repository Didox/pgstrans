class VendasConciliacaoController < ApplicationController

  def index_vendas_conciliacao
    sql = "
      SELECT  
        to_char(vendas.created_at #{SqlDate.fix_sql_date_query}, 'YYYY/MM/DD') as data_venda, 
        sum(vendas.valor_original) as valor, 
        sum(vendas.desconto_aplicado) as lucro, 
        sum(vendas.value) as custo
      FROM vendas 
      inner join usuarios on usuarios.id = vendas.usuario_id 
      inner join partners on partners.id = vendas.partner_id 
      WHERE vendas.created_at is not null
    "

    if params[:return_code].blank?
      params[:return_code] = "sucesso"
    end

    if params[:return_code].present?
      if params[:return_code] == "sucesso"
        status = ReturnCodeApi.where(sucesso: true).map{|r| "'#{r.return_code}'" }.join(",") rescue ""
        sql += " and vendas.status in (#{status})" if status.present?
      else
        ret = ReturnCodeApi.find(params[:return_code])
        sql += " and vendas.status = '#{ret.return_code}' and vendas.partner_id = #{ret.partner_id}"
      end
    end

    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      sql += " and usuarios.status_cliente_id = #{params[:status]}"
    end

    sql += " and vendas.updated_at >= '#{SqlDate.sql_parse(params[:data_inicio].to_datetime.beginning_of_day)}'" if params[:data_inicio].present?
    sql += " and vendas.updated_at <= '#{SqlDate.sql_parse(params[:data_fim].to_datetime.end_of_day)}'" if params[:data_fim].present?
    sql += " and vendas.partner_id = #{params[:parceiro_id]}" if params[:parceiro_id].present?

    if params[:status_parceiro_id].present?
      sql += " and partners.status_parceiro_id = #{params[:status_parceiro_id]}"
    else
      sql += " and partners.status_parceiro_id in (#{StatusParceiro::ATIVO_TEMPORARIAMENTE_INDISPONIVEL.join(",")})"
    end

    sql += "
      group by data_venda
      ORDER BY data_venda desc
    "
    
    @vendas = ActiveRecord::Base.connection.exec_query(sql)
    @vendas_total = @vendas.count
  end
end
