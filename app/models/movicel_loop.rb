class MovicelLoop < ApplicationRecord
	validates :usuario, :token, :uri, presence: true
	
	def processar!
		self.repeticao.times.each do |i|
			self.prepara_enviar(i)
		end
	end
	
	def prepara_enviar(index)
		loop_log = LoopLog.new
		loop_log.index = self.nropedidoinicio
		loop_log.movicel_loop_id = self.id
		loop_log.save!

		self.nropedidoinicio += (index + 1)
		self.save!

		self.enviar!(loop_log)
	end

	def enviar!(loop_log)
		require 'cgi'

		request_send = ""
		Thread.new do
			begin
				sleep(2)
				parceiro = Partner.where("lower(slug) = 'movicel'").first
				valor_original = self.valor
				parametro = Parametro.where(partner_id: parceiro.id).first

				telefone = self.terminal

				require 'openssl'

				url_service = self.uri
				agent_key = self.token
				user_id = self.usuario

				msisdn = telefone

				request_id = loop_log.index

				cripto = "AGENTKEY='#{agent_key}' USERID='#{user_id}' MSISDN='#{msisdn}' REQUESTID='#{request_id}' ./chaves/movicell/ubuntu/encripto"
				request_send += "=========[pass]========</div>"
				pass = `#{cripto}`
				request_send += "#{pass}<br>"
				request_send += "=========[pass]========</div>"

				pass = pass.strip

				request_send = ""
				response_get = ""
				last_request = ""

				request_send += "AGENTKEY='#{agent_key}' <br>"
				request_send += "USERID='#{user_id}' <br>"
				request_send += "MSISDN='#{msisdn}' <br>"
				request_send += "REQUESTID='#{request_id}' <br>"
				request_send += "cripto='#{cripto}' <br>"

				body = "
					<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
						<soapenv:Header>
						<int:ValidateTopupReqHeader>
								<mid:RequestId>#{request_id}</mid:RequestId>
								<mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
								<mid:SourceSystem>#{user_id}</mid:SourceSystem>  
								<mid:Credentials>
									<mid:User>#{user_id}</mid:User>
									<mid:Password>#{pass}</mid:Password>
									</mid:Credentials>
								</int:ValidateTopupReqHeader>
						</soapenv:Header>
						<soapenv:Body>
								<int:ValidateTopupReq>
									<int:ValidateTopupReqBody>
											<mid1:Amount>#{valor_original}</mid1:Amount>
											<mid1:MSISDN>#{msisdn}</mid1:MSISDN>
									</int:ValidateTopupReqBody>
								</int:ValidateTopupReq>
						</soapenv:Body>
					</soapenv:Envelope>
				"

				body  = body

				data_envio = Time.zone.now

				request_send += "<div>=========[ValidateTopup - #{data_envio.to_s}]========</div>"
				request_send += cripto
				request_send += "<div>=========[ValidateTopup]========</div>"
				request_send += "<pre>#{CGI.escapeHTML(body)}</pre>"
				request_send += "<div>=========[ValidateTopup]========</div>"
				request_send += "<strong>========[Enviando para operadora Movicel - #{data_envio.to_s}]==========</strong>"

				url = "#{url_service}/DirectTopupService/Topup/"
				uri = URI.parse(URI.escape(url))
				request_send += "<div>=========[URI]========</div>"
				request_send += "<strong>#{url}</strong>"
				request_send += "<div>=========[URI]========</div>"
				
				begin
					payload = {
						headers: {
							'Content-Type' => 'text/xml;charset=UTF-8',
							'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/ValidateTopup',
						},
						timeout: DEFAULT_TIMEOUT.to_i.seconds,
						body: body
					}

					request_send += "<div>=========[payload - ValidateTopup]========</div>"
					request_send += "<pre>#{CGI.escapeHTML(payload.inspect)}</pre>"
					request_send += "<div>=========[payload - ValidateTopup]========</div>"

					request = HTTParty.post(uri, payload)

					request_send += "<strong>========[Dados enviados para operadora Movicel]==========</strong>"

					response_get += "=========[ValidateTopup - #{Time.zone.now.to_s} - Tempo de envio: #{Time.zone.now - data_envio} ]========</div>"
					response_get += "<pre>#{formata_html_request(request.body)}</pre>"
					response_get += "<div>=========[ValidateTopup]========</div>"

					if (200...300).include?(request.code.to_i) && request.body.include?("200</ReturnCode>")

						body = "
							<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:int=\"http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface\" xmlns:mid=\"http://schemas.datacontract.org/2004/07/Middleware.Common.Common\" xmlns:mid1=\"http://schemas.datacontract.org/2004/07/Middleware.Adapter.DirectTopup.Resources.Messages.DirectTopupAdapter\">
								<soapenv:Header>
										<int:TopupReqHeader>
											<mid:RequestId>#{request_id}</mid:RequestId>
											<mid:Timestamp>#{Time.zone.now.strftime("%Y-%m-%d")}</mid:Timestamp>
											<mid:SourceSystem>#{user_id}</mid:SourceSystem>
											<mid:Credentials>
													<mid:User>#{user_id}</mid:User>
													<mid:Password>#{pass}</mid:Password>
											</mid:Credentials>
										</int:TopupReqHeader>
								</soapenv:Header>
								<soapenv:Body>
										<int:TopupReq>
											<int:TopupReqBody>
													<mid1:Amount>#{valor_original}</mid1:Amount>
													<mid1:MSISDN>#{msisdn}</mid1:MSISDN>
													<mid1:Type>Default</mid1:Type>
											</int:TopupReqBody>
										</int:TopupReq>
								</soapenv:Body>
							</soapenv:Envelope>
						"
						body  = body

						data_envio = Time.zone.now
						request_send += "<div>=========[Topup - #{data_envio.to_s}]========</div>"
						request_send += "<pre>#{formata_html_request(request.body)}</pre>"
						request_send += "<div>=========[Topup]========</div>"
						request_send += "<strong>========[Enviando confirmação para operadora Movicel]==========</strong>"

						url = "#{url_service}/DirectTopupService/Topup/"
						request_send += "<div>=========[URI]========</div>"
						request_send += "<strong>#{url}</strong>"
						request_send += "<div>=========[URI]========</div>"

						uri = URI.parse(URI.escape(url))
						begin
							payload = {
								headers: {
									'Content-Type' => 'text/xml;charset=UTF-8',
									'SOAPAction' => 'http://ws.movicel.co.ao/middleware/adapter/DirectTopup/interface/DirectTopupService_Outbound/Topup',
								},
								timeout: 90.seconts,
								body: body
							}

							request_send += "<div>=========[payload - Topup]========</div>"
							request_send += "<pre>#{CGI.escapeHTML(payload.inspect)}</pre>"
							request_send += "<div>=========[payload - Topup]========</div>"

							request = HTTParty.post(uri, payload)
							
							response_get += "<div>=========[Topup - #{Time.zone.now.to_s} - Tempo de envio: #{Time.zone.now - data_envio}]========</div>"
							response_get += "<pre>#{formata_html_request(request.body)}</pre>"
							response_get += "<div>=========[Topup]========</div>"

							response_get += "<strong>========[Confirmação enviada para operadora Movicel]==========</strong>"

							last_request = request.body

							loop_log.request = request_send
							loop_log.response = response_get
							loop_log.save!
						end
					else
						loop_log.request = request_send = "#{request_send} - <pre>#{formata_html_request(request.body)}</pre>"
						loop_log.response = response_get
						loop_log.save!
					end
				rescue Exception => err
					loop_log.request = request_send = "#{request_send} - Erro ao enviar dados para api - URL = #{url} - payload = #{request_send} - Erro = #{err.message} - backtrace = #{err.backtrace}"
					loop_log.response = response_get
					loop_log.save!
				end
			rescue Exception => err
				loop_log.request = "Erro = #{request_send} - #{err.message} - backtrace = #{err.backtrace}"
				loop_log.save!
			end
		end
	end

	def formata_html_request(body)
		body = body.gsub(">", ">\n")
		CGI.escapeHTML(body)
	end
end