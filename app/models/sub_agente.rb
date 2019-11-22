class SubAgente < ApplicationRecord
	validates :razao_social, presence: true, uniqueness: true
	validates :nome_fantasia, :bi, :morada, presence: true
end
