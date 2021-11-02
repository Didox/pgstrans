class SubDistribuidor < ApplicationRecord
	include PermissionamentoDados
	validates :nome, presence: true, uniqueness: true
	validates :bi, :morada, :interface_operacao, presence: true

	belongs_to :municipio
	belongs_to :provincia, class_name: "Provincium", foreign_key: "provincia_id"
end
