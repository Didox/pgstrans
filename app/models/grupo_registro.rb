class GrupoRegistro < ApplicationRecord
  belongs_to :grupo

  def registro
    self.modelo.constantize.find(self.modelo_id)
  rescue
    nil
  end

end
