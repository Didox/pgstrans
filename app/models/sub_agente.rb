class SubAgente < ApplicationRecord
	validates :razao_social, presence: true, uniqueness: true
	validates :nome_fantasia, presence: true
	validates :bi, presence: true
	validates :morada, presence: true
end
