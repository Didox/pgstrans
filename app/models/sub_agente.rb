class SubAgente < ApplicationRecord
	include PermissionamentoDados
	validates :razao_social, presence: true, uniqueness: true
	validates :nome_fantasia, :bi, :morada, presence: true

	belongs_to :industry
	belongs_to :provincia, class_name: "Provincium", foreign_key: "provincia_id"
end
