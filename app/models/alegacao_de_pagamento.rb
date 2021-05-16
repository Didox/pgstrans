class AlegacaoDePagamento < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
  belongs_to :banco
end
