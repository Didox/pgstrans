class Industry < ApplicationRecord
  include PermissionamentoDados
	validates :descricao_seccao, :descricao_divisao, :descricao_grupo, presence: true
end
