class DistribuidorDesconto < ApplicationRecord
  belongs_to :sub_distribuidor
  belongs_to :partner
  belongs_to :desconto_parceiro
end
