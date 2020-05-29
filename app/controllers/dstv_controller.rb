class DstvController < ApplicationController
  def validacao_cliente

    if params[:smartcard].present?
      info = Dstv.informacoes(params[:smartcard])
    end
  end
  
  def alteracao_pacote
  end

  def alteracao_plano
  end
end
