class ProxyPayController < ApplicationController
   skip_before_action :verify_authenticity_token, only: [:conciliacao_proxy_pay]

   def pagamento_referencia
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

      @sucesso = ProxyPay.gerar_referencia(@usuario)
   rescue Exception => err
      @erro = "Pagamento por referência - Usuário não encontrado - #{err.message}"
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

      @sucesso = ProxyPay.apagar_referencia(@usuario)

      @usuario.nro_pagamento_referencia = ""
      @usuario.responsavel = usuario_logado
      @usuario.save

   rescue Exception => err
      @erro = "Pagamento por referência - Usuário não encontrado - #{err.message}"
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
      
      hash_signature = {
         "amount" => params["amount"],
         "custom_fields" => params["custom_fields"],
         "datetime" => params["datetime"],
         "entity_id" => params["entity_id"],
         "fee" => params["fee"],
         "id" => params["id"],
         "parameter_id" => params["parameter_id"],
         "period_end_datetime" => params["period_end_datetime"],
         "period_id" => params["period_id"],
         "period_start_datetime" => params["period_start_datetime"],
         "product_id" => params["product_id"],
         "reference_id" => params["reference_id"],
         "terminal_id" => params["terminal_id"],
         "terminal_location" => params["terminal_location"],
         "terminal_period_id" => params["terminal_period_id"],
         "terminal_transaction_id" => params["terminal_transaction_id"],
         "terminal_type" => params["terminal_type"],
         "transaction_id" => params["transaction_id"]
      }

      parceiro = Partner.proxypay
      parametro = Parametro.where(partner_id: parceiro.id).first
  
      if parametro.blank? || parceiro.blank?
         render json: {
            message: "Parceiro inválido"
         }, status: 401
         return 
      end
  
      if Rails.env == "development"
         api_key = parametro.get.api_key_desenvolvimento
      else
         api_key = parametro.get.api_key_producao
      end

      http_body = hash_signature.to_json

      signature = generate_signature(api_key, http_body)

      if request.headers["X-Signature"] != signature
         render json: {
            message: "Chave inválida"
         }, status: 401
         return 
      end

      hash = {
         nro_pagamento_referencia: params["reference_id"],
         id_parceiro: params["id"],
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
         period_id_parceiro: params["terminal_period_id"],
         period_end_datetime_parceiro: params["period_end_datetime"],
         fee_parceiro: params["fee"],
         entity_id_parceiro: params["entity_id"],
         custom_fields_parceiro: params["custom_fields"]
      }

      duplicado = PagamentoReferencia.where(id_parceiro: params["id"]).first   
      hash[:usuario_id] = usuario.id
      hash[:x_signature] = request.headers["X-Signature"]
      pagamento_referencia = PagamentoReferencia.new(hash)
      pagamento_referencia.responsavel = Usuario.proxypay
      pagamento_referencia.save
   
      if duplicado.blank?
         conta_corrente = ContaCorrente.new
         conta_corrente.banco_id = Banco.order("ordem_prioridade asc").first.id
         conta_corrente.valor = pagamento_referencia.valor
         conta_corrente.lancamento = Lancamento.where(nome: Lancamento::DEPOSITO).first || Lancamento.first
         conta_corrente.observacao = "Pagamento por referência número (#{pagamento_referencia.nro_pagamento_referencia}) do usuário #{usuario.id}/#{usuario.nome} - ID Parceiro #{params["id"]}."
         conta_corrente.usuario = usuario
         conta_corrente.iban = pagamento_referencia.nro_pagamento_referencia
         conta_corrente.responsavel = Usuario.proxypay
         conta_corrente.responsavel_aprovacao_id = Usuario.proxypay.id
         conta_corrente.partner_id = Partner.where(slug: 'proxypay').first.id
         conta_corrente.save!

         pagamento_referencia.status = true
         pagamento_referencia.data_conciliacao = DateTime.now
         pagamento_referencia.save

         render json: {}, status: 204
      else
         pagamento_referencia.status = false
         pagamento_referencia.save

         render json: {
            message: "Pagamento de referência já conciliado ID - #{params["id"]} - Valor: #{params["amount"]}"
         }, status: 404
         return
      end
   end
   
   def generate_signature(api_key, json_body)
      require 'openssl'
      require 'base64'
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), api_key, json_body)
   end
end