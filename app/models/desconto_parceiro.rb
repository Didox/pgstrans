class DescontoParceiro < ApplicationRecord
  belongs_to :partner

  validates :porcentagem, uniqueness: { scope: [:porcentagem, :partner_id] }

  has_many :remuneracao_descontos, :dependent => :delete_all

  before_validation :valor_maior_zero_desconto
 
  def valor_maior_zero_desconto
    self.errors.add(:porcentagem, "precisa ser maior que 0.1") if self.porcentagem < 0.1
  end
end
