class Venda < ApplicationRecord

	def request_send_parse
		JSON.parse(self.request_send.gsub(/\n|\t/, ""))
	end

	def response_get_parse
		JSON.parse(self.response_get.gsub(/\n|\t/, ""))
	end

  def self.fazer_venda(params)
  	raise "Produto não selecionado" if params[:unitel_produto_id].blank?
  	raise "Selecione o valor" if params[:valor].blank?
  	raise "Digite o telefone" if params[:unitel_telefone].blank?

		product_id = params[:unitel_produto_id].split("-").first
		telefone = params[:unitel_telefone]

  	venda = Venda.create(agent_id: 114250, product_id: product_id, value: params[:valor], client_msisdn: telefone)

		venda.store_id = 115356 ### http://localhost:3000/matrix_users/3 - campo PDV = 1
		venda.seller_id = 115709 ### http://localhost:3000/sub_agentes/1
		venda.terminal_id = "00244TP00221" ### http://localhost:3000/matrix_users/3 - campo terminal_id que será criado

		retorno = `./chaves/exec.sh #{venda.id} #{venda.product_id} #{venda.agent_id} #{venda.store_id} #{venda.seller_id} #{venda.terminal_id} #{venda.value} #{venda.client_msisdn}`
		venda.request_send, venda.response_get = retorno.split(" --- ")

		venda.save!

		venda
  end
end
