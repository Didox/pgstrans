module GruposHelper
  def grupos
    grupo = Grupo.all
    grupo = grupo.where(pai: false) if @grupo.pai
    grupo
  end
end
