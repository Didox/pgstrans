class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  belongs_to :moeda
  validates :valor_compra_telemovel, presence: true
  validates :valor_compra_site, presence: true

  def self.produtos
    Produto.where(status_produto: StatusProduto.where(nome: "Ativo")).where("data_vigencia is not null and data_vigencia >= ?", DateTime.zone.now)
  end
end

