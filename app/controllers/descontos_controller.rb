class DescontosController < ApplicationController
  def index
    @desconto_parceiros = DescontoParceiro.all
    options = {page: params[:page] || 1, per_page: 10}
    @desconto_parceiros = @desconto_parceiros.paginate(options)

    #@desconto_parceiros = DescontoParceiro.com_acesso(usuario_logado).order(partner_id: :asc)

    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.porcentagem = ?", params[:porcentagem]) if params[:porcentagem].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.updated_at >= ?", params[:updated_at_inicio].to_datetime.beginning_of_day) if params[:created_at_inicio].present?
    @desconto_parceiros = @desconto_parceiros.where("desconto_parceiros.updated_at <= ?", params[:updated_at_fim].to_date.end_of_day) if params[:updated_at_fim].present?
  end

  def lucros
    @parceiros = Partner.all
  end
end

