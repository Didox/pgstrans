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

  def traduzir_controle_acesso(data)
    return {
      "Industry" => "Negócio",
      "Parametro" => "Parametro",
      "StatusParceiro" => "StatusParceiro",
      "Provincium" => "Provincium",
      "CanalVenda" => "CanalVenda",
      "ReturnCodeApi" => "ReturnCodeApi",
      "StatusCliente" => "StatusCliente",
      "Remuneracao" => "Remuneracao",
      "Dispositivo" => "Dispositivo",
      "StatusAlegacaoPagamento" => "StatusAlegacaoPagamento",
      "Usuario" => "Usuario",
      "Lancamento" => "Lancamento",
      "StatusProduto" => "StatusProduto",
      "Partner" => "Partner",
      "Banco" => "Banco",
      "SubAgente" => "SubAgente",
      "SubDistribuidor" => "SubDistribuidor",
      "Moeda" => "Moeda",
      "TipoTransacao" => "TipoTransacao",
      "ContaCorrente" => "ContaCorrente",
      "Produto" => "Produto",
      "MasterProfile" => "MasterProfile",
      "MatrixUser" => "MatrixUser",
      "UniPessoalEmpresa" => "UniPessoalEmpresa",
      "Venda" => "Venda",
      "Country" => "Country",
    }[data]
  end
end
