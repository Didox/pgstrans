class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  validates :description, presence: true, uniqueness: true
  validates :valor_compra_telemovel, :valor_compra_site, :valor_minimo_venda_telemovel, :valor_minimo_venda_site, :margem_telemovel, :margem_site, presence: true
end

