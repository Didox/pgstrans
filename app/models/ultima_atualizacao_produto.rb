class UltimaAtualizacaoProduto < ApplicationRecord
  belongs_to :partner
  default_scope { order(updated_at: :desc) }
end
