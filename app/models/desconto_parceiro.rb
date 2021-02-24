class DescontoParceiro < ApplicationRecord
  belongs_to :partner

  validates :porcentagem, uniqueness: { scope: [:porcentagem, :partner_id] }

  has_many :remuneracao_descontos, :dependent => :delete_all

  before_validation :valor_maior_zero_desconto
 
  def valor_maior_zero_desconto
    self.errors.add(:porcentagem, "precisa ser maior que 0.1") if self.porcentagem < 0.1
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
