class TipoTransacao < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
