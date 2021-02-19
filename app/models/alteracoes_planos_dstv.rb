class AlteracoesPlanosDstv < ApplicationRecord
  belongs_to :usuario
  belongs_to :lancamento, optional: true
end
