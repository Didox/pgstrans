module GruposHelper
  def grupos
    grupo = Grupo.all
    grupo = grupo.where(pai: false) if @grupo.pai
    grupo
  end

  def usuarios_sem_grupo
    Usuario.where("
      usuarios.id not in (
        select usuario_id from grupo_usuarios
        where grupo_id = #{@grupo.id}
      )
    ")
  end
end
