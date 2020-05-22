class UltimaAtualizacaoReconciliacao < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner
end
