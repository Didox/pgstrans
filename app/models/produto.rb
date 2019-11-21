class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  validates :description, presence: true, uniqueness: true
  validates :valor_compra_telemovel, presence: true
  validates :valor_compra_site, presence: true
  validates :valor_compra_pos, presence: true
  validates :valor_compra_tef, presence: true
  validates :valor_minimo_venda_telemovel, presence: true
  validates :valor_minimo_venda_site, presence: true
  validates :valor_minimo_venda_pos, presence: true
  validates :valor_minimo_venda_tef, presence: true
  validates :margem_telemovel, presence: true
  validates :margem_site, presence: true
  validates :margem_pos, presence: true
  validates :margem_tef, presence: true
end

