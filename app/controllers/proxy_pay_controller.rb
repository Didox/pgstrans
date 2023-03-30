class ProxyPayController < ApplicationController
   skip_before_action :verify_authenticity_token, only: [:conciliacao_proxy_pay]

   def pagamento_referencia
      # criar
   rescue Exception => e
      flash[:error] = e.message
   end

   def gerar_referencia
      @usuario = Usuario.find(params[:usuario_id])

		if @usuario.nro_pagamento_referencia.blank?
         @erro = "Número de pagamento por referência não cadastrado para o usuário"
         @sucesso = false
         return
      end

      @sucesso = ProxyPay.gerar_referencia(@usuario.nro_pagamento_referencia)
   rescue
      @erro = "Pagamento por referência - Usuário não encontrado"
      @sucesso = false
      return
   end

   def apagar_referencia
      @usuario = Usuario.find(params[:usuario_id])

		if @usuario.nro_pagamento_referencia.blank?
         @erro = "Número de pagamento por referência não cadastrado para o usuário"
         @sucesso = false
         return
      end

      @sucesso = ProxyPay.apagar_referencia(@usuario.nro_pagamento_referencia)
   rescue
      @erro = "Pagamento por referência - Usuário não encontrado"
      @sucesso = false
      return
   end

   def conciliacao_proxy_pay
      hash = {
         transaction_id: params["transaction_id"],
         terminal_type: params["terminal_type"],
         terminal_transaction_id:  params["terminal_transaction_id"],
         terminal_location:  params["terminal_location"],
         terminal_id: params["terminal_id"],
         reference_id: params["reference_id"],
         product_id: params["product_id"],
         period_start_datetime: params["period_start_datetime"],
         period_id: params["period_id"],
         period_end_datetime: params["period_end_datetime"],
         parameter_id: params["parameter_id"],
         id: params["id"],
         fee: params["fee"],
         entity_id: params["entity_id"],
         datetime: params["datetime"],
         custom_fields: params["custom_fields"],
         amount: params["amount"]
      }

      api_key = "your API Key"
      http_body = hash.to_json

      signature = generate_signature(api_key, http_body)

      if request.headers["X-Signature"] != signature
         render json: {
            message: "Chave inválida"
         }, status: 401
         return 
      end


      PagamentoReferencia.create(hash)

      render json: {}, status: 204
   end

   def generate_signature(api_key, http_body)
      require 'openssl'
      require 'base64'

      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.digest(digest, api_key, http_body)
      signature = Base64.strict_encode64(hmac)
      return signature
   end
end