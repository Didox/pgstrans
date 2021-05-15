class AlegacaoDePagamento < ApplicationRecord
  belongs_to :usuario
  belongs_to :banco
end
