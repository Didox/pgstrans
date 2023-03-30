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
      usuario = Usuario.where(nro_pagamento_referencia: params["reference_id"]).first
      if usuario.blank?
         render json: {
            message: "Usuário não localizado"
         }, status: 404
         return 
      end

      hash = {
         nro_pagamento_referencia: params["reference_id"],
         id_trn_parceiro: params["id"],
         data_pagamento: params["datetime"],
         transaction_id_parceiro: params["transaction_id"],
         valor: params["amount"],
         terminal_id_parceiro: params["terminal_id"],
         terminal_location_parceiro: params["terminal_location"],
         terminal_type_parceiro: params["terminal_type"],
         terminal_transaction_id_parceiro: params["terminal_transaction_id"],
         product_id_parceiro: params["product_id"],
         period_start_datetime_parceiro: params["period_start_datetime"],
         parameter_id_parceiro: params["parameter_id"],
         period_id_parceiro: params["period_id"],
         period_end_datetime_parceiro: params["period_end_datetime"],
         fee_parceiro: params["fee"],
         entity_id_parceiro: params["entity_id"],
         custom_fields_parceiro: params["custom_fields"]
      }

      parceiro = Partner.proxypay
      parametro = Parametro.where(partner_id: parceiro.id).first
  
      if parametro.blank? || parceiro.blank?
         render json: {
            message: "Parceiro inválido"
         }, status: 401
         return 
      end
  
      api_key = parametro.get.api_key_desenvolvimento
      http_body = hash.to_json

=begin
      signature = generate_signature(api_key, http_body)

      if request.headers["X-Signature"] != signature
         render json: {
            message: "Chave inválida"
         }, status: 401
         return 
      end
=end

debugger

      hash[:usuario_id] = usuario.id
      hash[:x_signature] = request.headers["X-Signature"]
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