class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  belongs_to :moeda
  validates :description, presence: true, uniqueness: true
  validates :valor_compra_telemovel, :valor_minimo_venda_telemovel, :valor_minimo_venda_site, :margem_telemovel, :margem_site, presence: true
end

