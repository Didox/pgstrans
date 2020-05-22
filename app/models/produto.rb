class Produto < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner
  belongs_to :status_produto
  belongs_to :moeda
  validates :description, presence: true, uniqueness: { scope: [:description, :partner_id] }
  validates :valor_minimo_venda_site, presence: true
end

