class Municipio < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
