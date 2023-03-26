class PagamentoReferencia < ApplicationRecord
    include PermissionamentoDados
    belongs_to :usuario
end
