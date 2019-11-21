class Industry < ApplicationRecord
	validates :descricao_seccao, :descricao_divisao, :descricao_grupo, presence: true
end
