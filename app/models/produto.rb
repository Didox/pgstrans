class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
end
