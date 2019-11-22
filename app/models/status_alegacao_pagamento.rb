class StatusAlegacaoPagamento < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
