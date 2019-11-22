class Banco < ApplicationRecord
	validates :nome, :sigla, presence: true, uniqueness: true
end
