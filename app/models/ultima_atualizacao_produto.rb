class UltimaAtualizacaoProduto < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner
end
