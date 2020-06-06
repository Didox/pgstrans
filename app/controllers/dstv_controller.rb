class DstvController < ApplicationController
  def validacao_cliente
    if params[:smartcard].present?
      @info = Dstv.informacoes(params[:smartcard])
    end
  end

  def consulta_fatura
   
  end

  def alteracao_cliente_produtos
    @produtos = Dstv.produtos
  end

  def alteracao_pacote
    if params[:smartcard].present?
      @info = Dstv.informacoes(params[:smartcard])
    end
  end

  def alteracao_plano
  end
end
