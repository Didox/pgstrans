class UniPessoalEmpresa < ApplicationRecord
	validates :nome, uniqueness: true, presence: true
end
