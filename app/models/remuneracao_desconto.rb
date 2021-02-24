class RemuneracaoDesconto < ApplicationRecord
  belongs_to :remuneracao
  belongs_to :partner
  belongs_to :desconto_parceiro, optional: true

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
