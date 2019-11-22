class Dispositivo < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
	validates :marca, presence: true
end
