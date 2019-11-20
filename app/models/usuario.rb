class Usuario < ApplicationRecord
	validates :email, presence: true, uniqueness: true
	validates :email, presence: true
end
