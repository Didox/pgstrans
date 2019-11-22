class StatusCliente < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
