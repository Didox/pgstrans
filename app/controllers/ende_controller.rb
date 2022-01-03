class EndeController < ApplicationController
    
  def confirmar_cliente
    if params[:customer_number].present?
      @info = Ende.informacoes_customer_number(params[:customer_number])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end
  
  def venda_teste
    if params[:ende_medidor].present?
      @info, @xml = Ende.venda_teste(params[:ende_produto_id], params[:ende_medidor])
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

  def reprint
    if params[:customer_number].present?
      @info = Ende.reprint(params[:customer_number])
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

end
