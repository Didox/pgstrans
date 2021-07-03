class StatusAlegacaoDePagamento < ApplicationRecord
	include PermissionamentoDados
	validates :nome, presence: true, uniqueness: true

	PADRAO = "Pendente"
	CANCELADO = "Cancelado"
	REJEITADO = "Rejeitado"
	INVALIDO = "Inválido"
	PROCESSADO = "Processado"
	PENDENTE = "Pendente" 
end
