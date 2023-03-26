class ProxyPayController < ApplicationController

   def pagamento_referencia
      # criar
   rescue Exception => e
      flash[:error] = e.message
   end

   def gerar_referencia
      usuario = Usuario.find(params[:usuario_id])

      xx = ProxyPay.gerar_referencia(usuario.referencia)
      puts xx
   end

end