class Banco < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
