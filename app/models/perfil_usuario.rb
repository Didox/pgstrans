class PerfilUsuario < ApplicationRecord
	validates :nome, presence: true, uniqueness: true
end
