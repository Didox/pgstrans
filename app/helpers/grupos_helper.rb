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
      "Industry" => "Actividades Económicas",
      "Parametro" => "Parâmetros de Integração",
      "StatusParceiro" => "Situação de Parceiros",
      "Provincium" => "Províncias",
      "CanalVenda" => "Canais de Venda",
      "ReturnCodeApi" => "Códigos de Retorno das APIs",
      "StatusCliente" => "Situação de Usuários",
      "Remuneracao" => "Remuneração Clientes",
      "Dispositivo" => "Dispositivos",
      "StatusAlegacaoPagamento" => "Situação de Alegações de Pagamentos",
      "Usuario" => "Usuários",
      "Lancamento" => "Tipos de Lançamentos",
      "StatusProduto" => "Situação de Produtos",
      "Partner" => "Parceiros",
      "Banco" => "Bancos",
      "SubAgente" => "Subagentes",
      "SubDistribuidor" => "Subdistribuidores",
      "Moeda" => "Moedas",
      "TipoTransacao" => "Tipos de Transação",
      "ContaCorrente" => "Conta Corrente",
      "Produto" => "Produtos",
      "MasterProfile" => "Perfil Master",
      "MatrixUser" => "Matriz de Usuários",
      "UniPessoalEmpresa" => "Tipo de Usuário Unipessoal / Empresa",
      "Venda" => "Vendas",
      "Country" => "Países",
    }[data]
  end
end
