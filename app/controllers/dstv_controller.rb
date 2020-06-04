class DstvController < ApplicationController
  def validacao_cliente

    if params[:smartcard].present?
      @info = Dstv.informacoes(params[:smartcard])
    end
  end

  def validacao_cliente_produtos
    @produtos = Dstv.produtos
  end

  def validacao_cliente_produtos
    @produtos = Dstv.produtos
  end
  
  def alteracao_pacote
  end

  def alteracao_plano
  end
end
