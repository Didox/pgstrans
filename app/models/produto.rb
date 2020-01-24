class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  belongs_to :moeda
  validates :description, presence: true, uniqueness: { scope: [:description, :partner_id] }
  validates :valor_compra_telemovel, presence: true

  def valor_minimo_venda_site
  	return super if super.present?
  	return self.valor_compra_telemovel
  end
end

