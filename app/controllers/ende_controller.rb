class EndeController < ApplicationController
    
  def confirmar_cliente
    if params[:customer_number].present?
      @info = Ende.informacoes_customer_number(params[:customer_number], request.remote_ip)
    end
    return [true, nil]
  rescue Exception => e
    flash[:error] = e.message
    return [false, e]
  end

  def reprint
  end

end
