class Dispositivo < ApplicationRecord
  include PermissionamentoDados
	validates :nome, presence: true, uniqueness: true
	validates :marca, presence: true
end
