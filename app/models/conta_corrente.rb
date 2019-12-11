class ContaCorrente < ApplicationRecord
  belongs_to :usuario
  belongs_to :lancamento
  belongs_to :banco
end
