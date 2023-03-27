class ProxyPayController < ApplicationController

   def pagamento_referencia
      # criar
   rescue Exception => e
      flash[:error] = e.message
   end

   def gerar_referencia
      usuario = Usuario.find(params[:usuario_id])

		if usuario.nro_pagamento_referencia.blank?
         @erro = "Número de pagamento por referência não cadastrado para o usuário"
         @sucesso = false
         return
      end

      @sucesso = ProxyPay.gerar_referencia(usuario.nro_pagamento_referencia)
   rescue
      @erro = "Pagamento por referência - Usuário não encontrado"
      @sucesso = false
      return
   end

end