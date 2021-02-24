class Produto < ApplicationRecord
  belongs_to :partner
  belongs_to :status_produto
  belongs_to :moeda
  validates :valor_compra_telemovel, presence: true
  validates :valor_compra_site, presence: true

  def self.produtos
    Produto.where(status_produto: StatusProduto.where(nome: "Ativo"))
  end

  after_create do 
    Log.save_log("Inclusão de registro (#{self.class.to_s})", self.attributes)
  end

  before_update do 
    Log.save_log("Alteração de registro (#{self.class.to_s})", self.attributes)
  end

  before_destroy do 
    Log.save_log("Exclusão de registro (#{self.class.to_s})", self.attributes)
  end

end

