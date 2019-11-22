class Lancamento < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
