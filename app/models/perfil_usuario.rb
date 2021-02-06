class PerfilUsuario < ApplicationRecord
  validates :nome, presence: true, uniqueness: true

  def acessos_parse
    self.acessos.present? ? JSON.parse(self.acessos) : []
  rescue
	 []
  end

  def acessos_actions
    acessos_parse.map{|a|a["acesso"]}
  rescue
    []
  end

  def acessos_views
    acessos_parse.map{|a|a["views"]}.uniq.compact.flatten
  rescue
    []
  end

  def self.tem_acesso?(administrador, controller, action)
    return administrador.acessos.include? "#{controller}::#{action}"
  rescue
    false
  end

  def self.menu(administrador)
    controllers = administrador.acessos.map{|a| a.split("::")[0] }
    actions = administrador.acessos.map{|a| a.split("::")[1] }
    menus = Menu.where(controller: controllers, action: actions)
    return [] if menus.count == 0

    secoes = menus.pluck(:secao).compact.uniq
    menu = {}
    secoes.each do |secao|
      menu[secao] = Menu.where(secao: secao, controller: controllers, action: actions)
    end

    menu
  end

  def self.action_amigavel(action)
    nomes = {
      new: "Mostrar a tela que permite a inclusão de um novo registo",
      index: "(INDEX) Mostrar a lista de todos os registos ou serviços dessa sessão",
      update: "(UPDATE) Permitir a atualização de registo",
      create: "(CREATE) Pemitir a efetivação da criação de um novo registo",
      destroy: "(DELETE) Permitir apagar registo",
      show: "(SHOW) Permitir mostrar detalhes do registo",
      edit: "(EDIT) Permitir mostrar tela de edição do registo",
      atualiza_saldo: "Fazer consulta de saldo no parceiro, caso o parceiro ofereça esse serviço",
      confirma: "Efectuar recarga, fazer pagamento e outras transações disponíveis na operadora",
      usuarios: "Usuários",
      apaga_acesso_usuario: "Apaga grupo de acesso de usuário",
      cria_acesso_usuario: "Cria grupo de acesso de usuário",
      novo_acesso_usuario: "Tela de criação de novo acesso do usuário",
      #resumido: "(VENDAS RESUMIDAS) Relatório de Pagamentos de Fatura DSTV / Lista somente as vendas do usuário e dos seus vendedores em se tratando de agente",
      resumido: "(VENDAS RESUMIDAS) Relatório de Pagamentos de Fatura DSTV",
      importa_produtos: "Acesso ao botão 'Atualizar portfólio de produtos ZAP'",
      importa_dados: "Acesso ao botão 'Importar dados para relatório de conciliação ZAP'",
      validacao_cliente: "Validação e consulta da situação do cliente",
      consulta_fatura: "Consulta valor e data do vencimento da fatura",
      alteracao_pacote: "Alteração de pacote de produtos",
      alteracao_plano: "Alteração de plano",
      alteracao_plano_mensal_anual: "Alteração de plano de cobrança alternando entre mensal e anual",
      alteracao_plano_mensal_anual_efetivar: "Alteração de plano de cobrança alternando entre mensal e anual (Efetivar)",
      alteracao_cliente_produtos: "Listagem de produtos em validação de pagamento DSTV",
      pagar_fatura: "Pagar fatura DSTV",
      reverter_venda_zaptv: "Reverter Vendas ZAPTV",
      index_morada_saldo: "Ver relatório de Conta corrente - Lista Saldo de Usuário (apresenta botão para ZERAR SALDO)",
      index_carregamento_usuario: "Ver relatório de Conta corrente - Lista de Carregamento por Usuário",
      forcar_logout: "Habilitar permissão para deslogar usuário (forçar logout após troca de senha)",
      controle_acessos: "Controle de Acesso",
      controle_acessos_edit: "Controle de Acesso EDITAR",
      controle_acessos_salvar: "Controle de Acesso SALVAR",
      controle_acessos_modelo: "Controle de Acesso MODELOS",
      controle_acessos_modelo_novo: "Controle de Acesso MODELOS (NOVO)",
      controle_acessos_modelo_salvar: "Controle de Acesso MODELOS (SALVAR)",
      controle_acessos_modelo_delete: "Controle de Acesso MODELOS (EXCLUIR)",
      lucros: "Relatório de Descontos e Lucro",
      movicel_loop: "Programa de Repetição Timeout Movicel",
      processar: "Processar dados",
      zerar_saldo: "Efetivar a ação de ZERAR SALDO de usuário presente em Conta Corrente / Lançamento em Conta Corrente de Usuário ",
     }
    return nil if ["usuario_logado", "administrador"].include?(action)
    nomes[action.to_sym]
  end

  def self.nome_amigavel_controller(controller)
    nomes = {
      vendas: "Backoffice - Relatório de Vendas",
      menus: "Menus do Backoffice",
      status_alegacao_pagamentos: "Backoffice - Sessão de Conta Corrente - Tabela de Situações de Alegação de Pagamento",
      parametros: "Backoffice - Sessão de Transações - Parâmetros de Integração dos Parceiros",
      unitel_sequences: "Backoffice - Sessão de Transações - Controle de Sequência de Vendas da Unitel",
      relatorio_conciliacao_zaptvs: "Backoffice - Relatório de Reconciliação ZAPTV disponível no menu Parceiros",
      status_parceiros: "Backoffice - Sessão de Parceiros e Produtos - Tabela de Situação de Parceiros",
      conta_correntes: "Backoffice - Sessão de Conta Corrente - Consultar e Creditar Conta Corrente do Usuário",
      moedas: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Moedas",
      backoffice: "Menu Principal de Serviços do Backoffice",
      bancos: "Backoffice - Sessão de Conta Corrente - Tabela de Bancos",
      lancamentos: "Backoffice - Sessão de Conta Corrente - Tabela de Tipos de Lançamentos",
      tipo_transacaos: "Backoffice - Sessão de Transações - Tabela de Tipos de Transações",
      provincia: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Províncias",
      countries: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Países",
      canal_vendas: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Canais de Venda",
      dispositivos: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Dispositivos",
      status_clientes: "Backoffice - Sessão de Usuários - Tabela de Situação Usuários",
      uni_pessoal_empresas: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Tipo de Usuário Unipessoal ou Empresa",
      perfil_usuarios: "Backoffice - Sessão de Usuários - Tabela de Perfil de Usuários do Sistema",
      remuneracaos: "Backoffice - Sessão de Desconto / Remuneração / Margem - Definição da Remuneração dos Usuários",
      produtos: "Backoffice - Sessão de Parceiros e Produtos - Tabela de Produtos",
      status_produtos: "Backoffice - Sessão de Parceiros e Produtos - Tabela de Situação de Produtos",
      saldos: "Consulta a movimentação da sua conta corrente e visualiza o própio saldo",
      municipios: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Municípios",
      industries: "Backoffice - Sessão de Tabelas Auxiliares - Tabela de Actividades Económicas",
      usuarios: "Backoffice - Sessão de Usuarios - Tabela de Usuários",
      sub_agentes: "Backoffice - Sessão de Usuários - Tabela de Subagentes",
      sub_distribuidors: "Backoffice - Sessão de Usuários - Tabela de Subdistribuidores",
      master_profiles: "Backoffice - Sessão de Usuários - Tabela de Perfil Master do Usuário",
      partners: "Backoffice - Sessão de Parceiros e Produtos - Tabela de Parceiros",
      welcome: "MENU DO BACKOFFICE",
      recarga: "TELA DE VENDAS",
      return_code_apis: "Backoffice - Sessão de Transações - Tabela de Código de Retorno das APIs",
      matrix_users: "Backoffice - Sessão de Usuários - Matriz de Usuários",
      grupos: "Grupos de Acesso",
      dstv: "DSTV",
      sequencial_dstvs: "Backoffice - Sessão de Transações - Controle de Sequência de Vendas da DSTV",
      log_vendas: "Log de vendas não realizadas",
      pagamentos_faturas_dstvs: "Pagamentos de fatura DSTV",
      alteracoes_planos_dstvs: "Alteração de planos DSTV",
      desconto_parceiros: "Desconto para parceiros",
      descontos: "Tabela de Descontos de Parceiros index",
      movicel_loops: "Timeout Movicel Programa de Repetição/Looping para coleta de logs",
      loop_logs: "Logs do Programa de Repetição/Looping para coleta de logs"
    }
    nomes[controller.to_sym]
  end
end
