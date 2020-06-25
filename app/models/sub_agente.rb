class SubAgente < ApplicationRecord
	include PermissionamentoDados
	validates :razao_social, presence: true, uniqueness: true
	validates :nome_fantasia, :bi, :morada, presence: true

	belongs_to :uni_pessoal_empresa, class_name: "UniPessoalEmpresa", foreign_key: "unipessoal_empresa_id"
	belongs_to :industry
	belongs_to :provincia, class_name: "Provincium", foreign_key: "provincia_id"
end
