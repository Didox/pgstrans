class Parametro < ApplicationRecord
  include PermissionamentoDados
  belongs_to :partner

  def get
    OpenStruct.new(JSON.parse(self.dados))
  rescue
    OpenStruct.new
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
