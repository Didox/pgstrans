class Banco < ApplicationRecord
  include PermissionamentoDados
	validates :nome, :sigla, presence: true, uniqueness: true
end
