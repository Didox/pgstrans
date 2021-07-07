class StatusAlegacaoDePagamento < ApplicationRecord
	include PermissionamentoDados
	validates :nome, presence: true, uniqueness: true

	PADRAO = "Pendente"
	CANCELADO = "Cancelado"
	REJEITADO = "Rejeitado"
	INVALIDO = "Inválido"
	PROCESSADO = "Processado"
	PENDENTE = "Pendente" 
	REJEITADO = "Rejeitado"
	INVALIDO = "Inválido"
	EM_ANALISE = "Em Análise"
end
