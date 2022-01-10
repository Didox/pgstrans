class EndeController < ApplicationController
    
  def confirmar_cliente
    if params[:meter_number].present?
      @info = Ende.informacoes_meter_number(params[:meter_number])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end
  
  def venda_teste
    if params[:meter_number].present?
      @info, @xml = Ende.venda_teste(usuario_logado, params[:ende_produto_id], params[:meter_number], params[:valor])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

  def reprint
    if params[:meter_number].present?
      @info, @xml = Ende.reprint(params[:meter_number])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

  def last_advice
    if params[:date_time].present? && params[:unique_number].present?
      @info = Ende.last_advice(params[:date_time], params[:unique_number])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

  def pagamento_de_conta
    if params[:numero_conta].present? && params[:valor_pagamento].present?
      @info = Ende.pagamento_de_conta(params[:numero_conta], params[:valor_pagamento])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

end
