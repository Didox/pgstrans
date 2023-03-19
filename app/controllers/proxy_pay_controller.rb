class ProxyPayController < ApplicationController

   def pagamento_referencia
      # criar
   end

   rescue Exception => e
      flash[:error] = e.message

end