class Industry < ApplicationRecord
  include PermissionamentoDados
	validates :descricao_seccao, presence: true
end
