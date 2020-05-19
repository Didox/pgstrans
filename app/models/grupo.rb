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
end
