class RemuneracaoDesconto < ApplicationRecord
  belongs_to :remuneracao
  belongs_to :partner
  belongs_to :desconto_parceiro, optional: true
end
