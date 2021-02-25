class Grupo < ApplicationRecord
  default_scope { order('id asc') }

  def hierarquia
    self.get_pai
  end

  def grupo_pai
    return nil if !self.grupo_id
    Grupo.find(self.grupo_id)
  rescue
    nil
  end

  def get_pai(grupo=self, lista=[], top=1)
    return lista if top >= 1000
    grupo = grupo.grupo_pai
    return lista if !grupo
    lista << grupo
    return get_pai(grupo, lista, top+1)
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
