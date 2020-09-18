class DescontosController < ApplicationController
  def index
    @desconto_parceiros = DescontoParceiro.all

    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.partner_id = ?", params[:parceiro_id]) if params[:parceiro_id].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.porcentagem >= ?", params[:porcentagem_de].to_f_ptBR) if params[:porcentagem_de].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.porcentagem <= ?", params[:porcentagem_ate].to_f_ptBR) if params[:porcentagem_ate].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.updated_at >= ?", params[:updated_at_inicio].to_datetime.beginning_of_day) if params[:updated_at_inicio].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.updated_at <= ?", params[:update_at_fim].to_date.end_of_day) if params[:update_at_fim].present?

    options = {page: params[:page] || 1, per_page: 10}
    @desconto_parceiros = @desconto_parceiros.paginate(options)
  end

  def lucros
    @parceiros = Partner.all
  end
end

