class StatusParceiro < ApplicationRecord
	include PermissionamentoDados
  ATIVO_TEMPORARIAMENTE_INDISPONIVEL = [1,6]
  ATIVO = 1
end
