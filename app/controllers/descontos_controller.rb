class DescontosController < ApplicationController
  def index
    @desconto_parceiros = DescontoParceiro.all
    options = {page: params[:page] || 1, per_page: 10}
    @desconto_parceiros = @desconto_parceiros.paginate(options)
  end

  def lucros
    @parceiros = Partner.all
  end
end
