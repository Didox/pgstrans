class EndeController < ApplicationController
    
  def confirmar_cliente
    @info = []
    if params[:meter_number].present?
      @info, @xml_enviado, @xml_recebido = Ende.informacoes_meter_number(params[:meter_number])
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end
  
  def venda_teste
    @info = []
    if params[:meter_number].present?
      @info, @xml = Ende.venda_teste(usuario_logado, params[:ende_produto_id], params[:meter_number], params[:valor])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def reprint
    @info = []
    if params[:meter_number].present?
      @info, @xml = Ende.reprint(params[:meter_number])
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def last_advice
    @info = []
    if params[:date_time].present? && params[:unique_number].present?
      @xml_enviado, @xml_recebido = Ende.last_advice(params[:date_time], params[:unique_number])
      @info = Ende.informacoes_parse(@xml_recebido, EndeUniqNumber.find(params[:unique_number]))
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

  def pagamento_de_conta
    @info = []
    if params[:numero_conta].present? && params[:valor_pagamento].present?
      @info = Ende.pagamento_de_conta(params[:numero_conta], params[:valor_pagamento])
    end
  rescue Exception => e
    flash[:error] = e.message
    @info = []
  end

end
