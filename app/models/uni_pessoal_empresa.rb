class UniPessoalEmpresa < ApplicationRecord
	include PermissionamentoDados
	validates :nome, uniqueness: true, presence: true
end
