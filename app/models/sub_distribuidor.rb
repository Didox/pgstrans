class SubDistribuidor < ApplicationRecord
	include PermissionamentoDados
	validates :nome, presence: true, uniqueness: true
	validates :bi, :morada, :interface_operacao, presence: true

	belongs_to :municipio
	belongs_to :provincia, class_name: "Provincium", foreign_key: "provincia_id"

	def porcentagem(partner_id)
		dp = DistribuidorDesconto.where(sub_distribuidor_id: self.id, partner_id: partner_id).first
		dp.desconto_parceiro.porcentagem
	rescue
		0
	end
end
